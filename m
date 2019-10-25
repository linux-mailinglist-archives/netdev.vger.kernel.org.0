Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDC9E4212
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404155AbfJYDYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:24:17 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38995 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404099AbfJYDYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:24:17 -0400
Received: by mail-qt1-f195.google.com with SMTP id t8so1214719qtc.6;
        Thu, 24 Oct 2019 20:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kfzkL6TE8WPhbRbi/HKbsmlwchYESe/XvgS4xp0Hf6c=;
        b=PVT3Nx31BlPJvcB/CUZIjtCXG588la1e64yqn3ipbefW+8z+oj2ftKkkLkN/wpv8//
         3RbE7p4PyiAM/z8aMUVbye1aOe0Un/Z603iaUyTer3yX7c9I7OvrRzi5T+DO7SGcP10K
         5XMQZsGascBKACmB82pKd0lLO41f41nAXYz+uvzZqfpEiA5QgBlkGVxf/CAz17DeM6Ah
         Nrf3rNg9HO4SiKqBQasnLK27nryEscrQYBFzt9498EUrDB7S59apDoGLlQ5dca3dHHyY
         iEttKoefR818AdlDz4eMGpunzBC+qJHEac+DYiCBBfySmBtzmRns49WoBAweHIhh26pL
         apfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kfzkL6TE8WPhbRbi/HKbsmlwchYESe/XvgS4xp0Hf6c=;
        b=trHS2cHAju+t9IDXPAoOS6IMEA6ju0lboEO/pJDrQpaOjjVSWfI9KtrXXzoOmhWJPH
         EuD0cyhUCKVCC62KBjVIYmru0IdHRLxcNRq4KO4rAQ/YTMO1EsI6Hbo/FhYQ8b5534D2
         Jst06dtyWWdCnpMwR/Xjb/9V9O2fEZ7mNksTfnDCzQNVIZlp+57Y3WvcvUTAc7F/4K0T
         AhSaEzSPGVGkExoM3dy0swFYASTdKCD5XzTP/g/5pv/2wSov8fxeWVmx4LtlYl1ySZrc
         4gnb+gKl0ZaKUCVIx0C0tUA+525X8GR3MachtVrw9WZwRrvxcVAlREX9VSVyOeH/EhJX
         R1vQ==
X-Gm-Message-State: APjAAAV19SQ0XpGJtU7Dc4YHVs0aBMeDNm+3U76mvR/1qQcJ9TeNGcRS
        30wBR6ktI2eJMYP5eGJiPU8=
X-Google-Smtp-Source: APXvYqwxLm6R0FO93sFxZyTgMyE28Tt6fjR7QPCfA5aQK5GyYxru66RU7QvfISkYK6OspAjwHPYFDA==
X-Received: by 2002:ad4:4cd2:: with SMTP id i18mr1185152qvz.179.1571973856100;
        Thu, 24 Oct 2019 20:24:16 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.193])
        by smtp.gmail.com with ESMTPSA id x7sm586211qkj.74.2019.10.24.20.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 20:24:15 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A5C1FC0AD9; Fri, 25 Oct 2019 00:24:12 -0300 (-03)
Date:   Fri, 25 Oct 2019 00:24:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: Re: [PATCHv3 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-ID: <20191025032412.GD4326@localhost.localdomain>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 02:14:46PM +0800, Xin Long wrote:
> This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> the Potentially Failed Path State", by which users can change
> pf_expose per sock and asoc.
> 
> v1->v2:
>   - no change.
> v2->v3:
>   - return -EINVAL if params.assoc_value > SCTP_PF_EXPOSE_MAX.
>   - define SCTP_EXPOSE_PF_STATE SCTP_EXPOSE_POTENTIALLY_FAILED_STATE.

Hm, why again? Please add it to the changelog, as it's an exception on
the list below.

> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/sctp.h |  2 ++
>  net/sctp/socket.c         | 79 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index d99b428..a190e4a 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -137,6 +137,8 @@ typedef __s32 sctp_assoc_t;
>  #define SCTP_ASCONF_SUPPORTED	128
>  #define SCTP_AUTH_SUPPORTED	129
>  #define SCTP_ECN_SUPPORTED	130
> +#define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
> +#define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
>  
>  /* PR-SCTP policies */
>  #define SCTP_PR_SCTP_NONE	0x0000
