Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2228E20A7EA
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391289AbgFYWAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 18:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390621AbgFYWAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:00:24 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E97AC08C5C1;
        Thu, 25 Jun 2020 15:00:24 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r18so3960370pgk.11;
        Thu, 25 Jun 2020 15:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GBzH//KmJweZqU1/t4NDIS0bmXLOLviC6svDPzdyyOU=;
        b=ovEAbNeoADhejrcUiR/6HkFpdj3T1nph5TiVN9nX370M9gg2pbnG12T930k7++sHfV
         Forn6VTlRAgwyxGMnZBmoFz9/AL37L7g/dIOrb/xMQDNCkrnixbnvQViR7KTvecMsCB1
         ufdYVecs/GCD8jMoHNvUFp2eoO+G7EJMoccx4FjZGhKt1G9A221dhFWkQ7JhgFwUnUvG
         46YcfTDkep9+1mrrOLqM1k1BoryUDIEbpgEovYm7UXAo2w7oGN/oisxa9BeubEcYr9xc
         QFFLXm9+OkYeoJ6c59/vUrA/tHR4IypB6fweoMq4vzFKwHiokVdaT/E4fFcD/1XUiErB
         D3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GBzH//KmJweZqU1/t4NDIS0bmXLOLviC6svDPzdyyOU=;
        b=V3Z3YOzvoOKYN2rCwsfBEXcmsH+0PNc/K4guhSOB/R7l7QpcVzIP87SKDWgwxFJPiH
         HKg14tC1DYViE8Se9FAfmGdNoQy/CnSdRhJEYGzdJhsSxmn2RWg1qRGXVyhO5VPt3XrY
         Cp1OyNG9t4FRQOOEcjioaQjb4KUKyjr36TVRdF49d42wq1uAOpWe9t10jt/+Cpo0CYe2
         5jSEStEpfcZxHumJTZdo+uumWc5VCzoic9CNGD+JgkBCNAAQDYjmIY5/XcjMnASU4EXZ
         sh0n3fI42ac9rlc8hnJNz8aDZRRZJq/qqr9BcFRyi08H8MFqFxVPpry9+5oqRD49zGqZ
         uHcg==
X-Gm-Message-State: AOAM532NLyNkI+hnnt+tZFZKxJ6oaxe5eXEVeOW0GdIKkj2KndeVrd/X
        sz1qvQyl7rdJj4KaSmYrPzkbj8arXprv1w==
X-Google-Smtp-Source: ABdhPJzU9yjQDKc53mVohB8PcCBFq+VAFz19hDFTx9L9+PjvpN7QtGGxkeJh0i6E5cg5C2Y7emnEvw==
X-Received: by 2002:aa7:85cd:: with SMTP id z13mr36414397pfn.321.1593122423657;
        Thu, 25 Jun 2020 15:00:23 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id j36sm21405968pgj.39.2020.06.25.15.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 15:00:23 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Fri, 26 Jun 2020 06:00:16 +0800
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        open list <linux-kernel@vger.kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] fix trailing */ in block comment
Message-ID: <20200625220016.g3wqthtauypxlp6g@Rk>
References: <20200625153614.63912-1-coiby.xu@gmail.com>
 <20200625153614.63912-2-coiby.xu@gmail.com>
 <20200625172510.GF2549@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200625172510.GF2549@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 08:25:10PM +0300, Dan Carpenter wrote:
>The subject isn't right (no subsystem prefix) and we need a commit
>message.
>
>regards,
>dan carpenter

Thank you for pointing out the exact problems!

--
Best regards,
Coiby
