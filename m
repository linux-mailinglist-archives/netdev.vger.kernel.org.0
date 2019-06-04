Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD0834A34
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfFDOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:21:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36824 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfFDOVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:21:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id d21so8416564plr.3
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 07:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AebR9tH00SO0Q0XegEJSrhzcjQx4Xc3w7BoQjh1eAaI=;
        b=hRp+g4SCRo34X70vQeZbjlFM9nFfGvW9J2p2E0ANkg9QEt2DZ/gEzwna/8KaZFnRDF
         PIoxpvrkOVcda79uJyL+WjWKrDcFykWHAtnR+5riTLq41uUuFtUdNZWhT8eiznAXiBrU
         IhDOtZQ7YJQSTenXuGI7P4sCoS3tyKJSfbs3TQvtpJgpm4fS0DDwz1IoY/oa3MXa9onE
         HRlEhqtArohGGHxuKd8TFfztfQcNDq3hAGeC4JchaXwKs9o7q6OqtbTzaQ4wUKdQ0twK
         NslXB/CwAGrPBP8fZVs/EI9d1qKxpoj+2jnzW16SMwlgrRsoFRDEJYtMVKu2m+qmcwOn
         925w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AebR9tH00SO0Q0XegEJSrhzcjQx4Xc3w7BoQjh1eAaI=;
        b=BEHT4i3pTOn1VoEQIAK1v5rpq7AntsW9L9qwy0Tk8ZwRrIbdBOUqBejE3gFOzAGcgQ
         L/LLQ7OCsh929Wwm4hYuUsnisRaNVM9prqL8crdf9SRIaCjbVGVLb8iRPiUopett1RET
         b10s0Yl8l/TIkQpzxCDR+Xv4QOROEaekAZ8WhUJP+8CKxesb8Q0pWwm/JD8Di2b2a2/i
         icxPF4j2LkP57M6hs30qablEEPAXGWOvB5mYaCpBsr232j5NUegnukQG8nAIksxACweS
         lnUu6vEDUESGlLKoCEqeV4hx7qi9SQfWpKmagXfHV5GRsgwBxfdMmtgriNSIJRsqJazs
         +cdw==
X-Gm-Message-State: APjAAAVKHwQhoCUkaOTolug+cdqMIJuWDpVxau9aGW89COjn8Hz238BK
        qJVTp98eBNTYt4ZY0kZkJr0=
X-Google-Smtp-Source: APXvYqwLviH74Lsi9gMJVZORma9neOntUd6qvGLKukVgKD+A2d3iIEW3OeoJuaUpt5z+0BVFFxf/4Q==
X-Received: by 2002:a17:902:8ec3:: with SMTP id x3mr35804119plo.340.1559658068477;
        Tue, 04 Jun 2019 07:21:08 -0700 (PDT)
Received: from localhost (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id q17sm28278153pfq.74.2019.06.04.07.21.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 07:21:07 -0700 (PDT)
Date:   Tue, 4 Jun 2019 07:21:05 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 6/9] ptp: ptp_clock: Publish scaled_ppm_to_ppb
Message-ID: <20190604142105.5ckgkxshu4lcy6zc@localhost>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-7-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603121244.3398-7-idosch@idosch.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 03:12:41PM +0300, Ido Schimmel wrote:
> From: Shalom Toledo <shalomt@mellanox.com>
> 
> Publish scaled_ppm_to_ppb to allow drivers to use it.

But why?

> @@ -63,7 +63,7 @@ static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
>  	spin_unlock_irqrestore(&queue->lock, flags);
>  }
>  
> -static s32 scaled_ppm_to_ppb(long ppm)
> +s32 ptp_clock_scaled_ppm_to_ppb(long ppm)

Six words is a little bit much for the name of a function.

Thanks,
Richard
