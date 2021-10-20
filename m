Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B09435675
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhJTX0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTX0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 19:26:08 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA55C06161C;
        Wed, 20 Oct 2021 16:23:52 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id f4so9903172uad.4;
        Wed, 20 Oct 2021 16:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eJXVehUBRn1T9om9FLRN2qYFYq+b1Z9ko/H5l3M1U1Y=;
        b=ZLzMChFduRf5fZUJis2kEs+s1liRLZ8TJA/pudCCSDPRC3MNLh6t88btXsaqSGRdPE
         a0KdTpdqWppatKc2R3NGWZUlqYkZOmrz2PC45CRkCjrDVQOvNthtHQDNdicoY85TrfbM
         UlKlXSYYhjqAP/Mt4R+Ut1kSU7kqZrQQ/5REzYKALcqT1j9x0UVKG7P8tXZ5xGl+poHV
         aZuY50xcsWIumW7xHISje0FOX4lDMye1FMNGQ7B0kLUtsfpSmzI1Xg50fJsbhprDKKgG
         fxRTnhkIc6Q6bQGy8WK8FdjDxMjRKawr49/JvJUwGgyf5bjvVjEJ/cQ2l3zTetloLTfQ
         DM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eJXVehUBRn1T9om9FLRN2qYFYq+b1Z9ko/H5l3M1U1Y=;
        b=keowNQmuaDbvO+pxDEqmhXydX31MRRwEmn5j3Shqc+8uGSKY2yiGgC6a/RIaEG0nZr
         CGYxGJgOnIs++jyfaKg23U02HycYAI8HP79l3zlaWk75RXujGGPl155jqcwJGBUXgtWc
         hRFyh9M4k3OWEFDpKi3DOhwrT15Rv+N6kdau/JJmD53dU5IYQRowFU19vUxgYodFa6OP
         wU128WsY0Y5TxKcL9+Qzo/e1V/9sELvrjVq0XOhOhJavBF1X6eTBWPNho4u+eszJsu27
         oCmCKCQh73P5fTU1Hz3epxQNk6NkORMn9NiGn+JmrD44elGFymvSSwKCTU4y7/9j69n9
         tPZQ==
X-Gm-Message-State: AOAM5313Oofgd6gBoVYaY1V4Bddumg/6y1MjtaSowtLPyNdnqEuXQAbd
        xx0l3Hs8XXSP6H/Z8wohWbh6fqQln1w=
X-Google-Smtp-Source: ABdhPJy8MXFZYPDy5ieNrQdpKQQpbLdHFafGBRYMH39RUesG+3J6q6bWpj8raIUu96g3wknpXavL+w==
X-Received: by 2002:a9f:21b7:: with SMTP id 52mr2965560uac.9.1634772231839;
        Wed, 20 Oct 2021 16:23:51 -0700 (PDT)
Received: from t14s.localdomain ([177.220.174.164])
        by smtp.gmail.com with ESMTPSA id i39sm2190019vkd.48.2021.10.20.16.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 16:23:51 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id B8C5791A12; Wed, 20 Oct 2021 20:23:49 -0300 (-03)
Date:   Wed, 20 Oct 2021 20:23:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        michael.tuexen@lurchi.franken.de
Subject: Re: [PATCH net 0/7] sctp: enhancements for the verification tag
Message-ID: <YXClBfDfSFa/b8Fw@t14s.localdomain>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 07:42:40AM -0400, Xin Long wrote:
> This patchset is to address CVE-2021-3772:
> 
>   A flaw was found in the Linux SCTP stack. A blind attacker may be able to
>   kill an existing SCTP association through invalid chunks if the attacker
>   knows the IP-addresses and port numbers being used and the attacker can
>   send packets with spoofed IP addresses.

Please give me tomorrow to review it.

Thanks,
Marcelo
