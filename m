Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CAA483E55
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 09:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbiADImA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 03:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbiADIl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 03:41:59 -0500
Received: from mail-pg1-x565.google.com (mail-pg1-x565.google.com [IPv6:2607:f8b0:4864:20::565])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3D4C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 00:41:59 -0800 (PST)
Received: by mail-pg1-x565.google.com with SMTP id i8so23635515pgt.13
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 00:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tesca-id.20210112.gappssmtp.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=dZ9ZcTJ5j73nz7d+81ixbBYmVxHiHSM/dTKoNtPdL+4=;
        b=3g2WpLKiLvIsrZae55/DNvxoZDsiawrYH+Ubp2zF0aI7Skiwz+Q7mcE5lu1NqC34pi
         mrRXJoJRQEUAgnOYKvnx8qP0tAxAirtzbUANwWQka1WuCtRHKu9r8DcuDxpxHsw/X8YB
         3+DQuMt5pTxkJepX3N9O9xMUiWCQvGda2ZVFzzo8beK+3SU0DvjbysT/hiMCQGES96Q+
         sldN4L/1E5MHmdNPZhdp6VD7+sOCNp+hRfLAUJnUxruyrRQo4Wm7Wswlbvo17oESYCMy
         29cKAkeTfExCSmdqcAYYTgj0m0LVwT7vhlpK1VhGyiENu43xKpXBOrh4IFbFEyu1bLfv
         rK/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=dZ9ZcTJ5j73nz7d+81ixbBYmVxHiHSM/dTKoNtPdL+4=;
        b=p+k+w7X2kdkhZVq+6YQmERQWkG57a+4aTFTX+xBZ114zpZcabB3hptJgKYkh1qJQyC
         0nxuM78R1FElmHuQoKWcgvGfzcFHJlH2H3vQoTZ+u2iA1/0OrmnwiFbZRYLGc+VP/tr+
         vPoDnyor1HThjDvDJp4PuukzBBqmyWbGEfc0SUEE+ek4hxT9xgYsU0XZuL23nnuwc8qa
         X2r+3nVFSqfY3LnAEbbAgiBreNM+d3FBxl0U+KGhOwFknlvPyA2JokuoWSXeKOQT05WB
         icno6/k7aWpEzf5JWSWu7Y2p+JGbi3BPRWK5nVyLIcn76vos2HFVSkYmp/wiECRAquzf
         QX/Q==
X-Gm-Message-State: AOAM530xQ2zYGXlHqzV9SEF4D1IL6+NcufFCAuOvYOP54LnsvCjCPR0G
        LWKFlPzevZ/0MtT9btNb1aG7YxFkcS2LMD+JI27YXj88jZm38A==
X-Google-Smtp-Source: ABdhPJw2/7uoQzogviwQyg7SISmV9xJ5UmCRQ2jroviE5tvJ51rFLcF9rLDX68OV4kRTSogo0N1LM/bC3gUo
X-Received: by 2002:a63:7119:: with SMTP id m25mr16788447pgc.291.1641285718830;
        Tue, 04 Jan 2022 00:41:58 -0800 (PST)
Received: from [192.168.1.4] ([36.37.185.94])
        by smtp-relay.gmail.com with ESMTPS id hk6sm10113420pjb.5.2022.01.04.00.41.54
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 04 Jan 2022 00:41:58 -0800 (PST)
X-Relaying-Domain: tesca.id
Message-ID: <61d40856.1c69fb81.5d4dd.2b81SMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Joint Investment Proposal
To:     Recipients <no-reply@tesca.id>
From:   "Mr. David Cheung" <no-reply@tesca.id>
Date:   Tue, 04 Jan 2022 15:41:47 +0700
Reply-To: davdcheung@aol.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm David Cheung, A senior staff with public Bank in Cambodia. I have a bus=
iness proposal that gain the benefit for both of us to share with you.

Kindly get back to me as soon as possible.

Many thanks,
David Cheung =A9
