Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 614E64ABFC5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344399AbiBGNq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448959AbiBGNOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:14:00 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A17C043189
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 05:13:59 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id u13so16876630oie.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 05:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=+zB79ok8+scrzrgYKxLKHdTPGXHaNMs4/kAV8iB60HM=;
        b=Pi9V3QqXxWgxexrk5tCqcDwWVE5Rf6JZM4GCTeSviBlmU5tK4H4jYXcPv4ZhEVUcLb
         vUQbb3jsI0sApRdqguR8PZ0ptW1vyZTZNGauOtt46NfP0B+JnTVnytLGPG8rE/4SLYuB
         4k6Z/0RnFpuKTk8NyDjBAeMvQfcH8QI4KnMwHI34ocpFQacJhmZ3poOn+lKEWltGTw0Z
         McyOybM9d0zKmfny8SkhC5RIRIPUJfxPiW4qLOULWH5yzwufNIoZ+P/cmdb6iHaj2Xtc
         gptpdShyuG/sM8zohBjRrJnzk8aDn/RbyH6ei8QjjbJfKK/VVrO5dJZ2LDn/qV6jfhTs
         lO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=+zB79ok8+scrzrgYKxLKHdTPGXHaNMs4/kAV8iB60HM=;
        b=hN5YGYKpq5PvheBNpLdrw2KjrGr017R36+jX4iLE8PStM1NrH1GU6a0q/tEJJTx/F5
         493uadXipMhKpwsn614/RKoqr3wGKlAi0U2SACZkLmV0Ua9ssIharduRCEsbun0SrJJr
         Rfyryh9mxVUzBMbv5VNgMpyyDO6rSGlqi6h209jRZc0tlP3mzjDro/HSSNLIrq6lDsFG
         JuygwC3qXanQCt5fP+6uAvjWFPc0ToAuz2xTWIE2NFCnHuQxPkVLYXfI4ePkiwDGu4R5
         EA/eTDMdYpzc/6mtcfEEvkFONBB1MFIee2t8LIgLtgkT6V912FJcdv+7NML1SkxGYQMg
         LVgg==
X-Gm-Message-State: AOAM531DBSiHAk836uouUAkfZrVAYuzdM/lviiehGPN1RTwpCEVRCNUD
        sbqs1huEfSQO/6einX3w7kHSB/Lt9m+6juAkHAM=
X-Google-Smtp-Source: ABdhPJy2cHlBNISZmkmXMO1bd5o6RvYj0AnnhfVbfRkf1WQ/6PN5unIzEkHINDqefEe2t+xA96U/YBsTRbfWvj3PsUI=
X-Received: by 2002:a05:6808:ec2:: with SMTP id q2mr5088471oiv.310.1644239638202;
 Mon, 07 Feb 2022 05:13:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: avas58158@gmail.com
Sender: friederikerebmann915@gmail.com
Received: by 2002:a05:6830:4010:0:0:0:0 with HTTP; Mon, 7 Feb 2022 05:13:57
 -0800 (PST)
From:   Ava Smith <avas58158@gmail.com>
Date:   Mon, 7 Feb 2022 05:13:57 -0800
X-Google-Sender-Auth: pOvvhspzSQm9hX6WS7G9tA4KIdY
Message-ID: <CA+xNjepPWm+DwOJSkuGvDi7OW6hJ3UKfF5huBFj172an7dc2LQ@mail.gmail.com>
Subject: From Ava
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

My name is Ava Smith from United States. I am a French and American
national (dual) living in the U.S and sometimes in the U.K for the
Purpose of Work. I hope you consider my friend request and consider me
Worthy to be your friend. I will share some of my pics and more
details about myself when i get your response.

Thanks

Ava Smith
