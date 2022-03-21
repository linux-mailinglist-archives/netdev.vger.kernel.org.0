Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DCC4E2EBB
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 18:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351577AbiCURFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbiCURFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 13:05:36 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A514A58811
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:04:10 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id k6so6132321plg.12
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 10:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5dd9v1XJXx84cs8sYso6k6FrjCbQMawM1UqpQcsg7ZY=;
        b=E2BDd74223+shKxU9upHXb6Xkmf0ZU2ve2CZuw1BiOQeVp1ZtUYrA8GJAEfGWV36HL
         wIsXV47xOg0OWGnYJAAw+UBwRKWdc4pV61LT3cEEMWwKaGg0A2KrnT6sMYmFST5ZxsJh
         nYKZ5ULb3dfgaEvIWXLj39tj7kQ1vmK5NjEIeqNpx6ssViImG8SyHF5buo6ccE7dtO0G
         Y3UFVYtH2WPwom+6z7nvzoSBRSaFaqn/RfGL2gmU/TrbVGw1f8T0YNfVTtuG7TT56lra
         VfiaPwKCZRPqSah7OzRxl9RxM6DJiyEFpX6e1Ou40bPC82jbJyR6RBJleEiUxc6HqJIx
         sOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5dd9v1XJXx84cs8sYso6k6FrjCbQMawM1UqpQcsg7ZY=;
        b=Ity2MJ6EddDcMR8gXrMPkySW3hjmmDJFN7J9o+4sJTj/PKE81sfqEJdG9nx7GzMJc1
         wFWnj3SclLJOZTNr+Jj79ovpjQzIOJrwe1qKi5YXQByyJBPA5UX36puRlzkEp3FOEXKp
         sOGBeNlXQ95tgAcrdDAVkp8lBtn2Hqiuo0ObcMcq7F64XsfAIFIwQpWqD4NGBqv6ryZ3
         R/KZ5w857/KZ7DurrCdKffsHSC8qSbvEqtxT9L6pmRIopgYtDv2bf1fnTClum6Hvd/Aq
         awD02HwesLXh1si9iI3vwmtuJbl+TvBLtaFzMmxBMRuw/Py5S+29/Vh8MqbjSiC6p3pc
         Nvbg==
X-Gm-Message-State: AOAM532oLKQKK8WDmAO6FzvMvzWGzCk4XLkLo9cX8/dqkpG+XiXHMEq+
        frV55cSIcSxGeSnLKHjRlY1lbknK2WPtzAnxYV0DFMzM
X-Google-Smtp-Source: ABdhPJyQyghtZaJMb2xwQP+bBX8b1WZE14eZrMgpxhlDEKTGqc6ideoH1vyfklsCi2DOal+0C/lOLgZ+E9wffOlFP6E=
X-Received: by 2002:a17:90b:3b8c:b0:1c6:eb72:24b4 with SMTP id
 pc12-20020a17090b3b8c00b001c6eb7224b4mr45533pjb.171.1647882250235; Mon, 21
 Mar 2022 10:04:10 -0700 (PDT)
MIME-Version: 1.0
From:   Andreas Svensson <andreas93.svensson@gmail.com>
Date:   Mon, 21 Mar 2022 18:03:59 +0100
Message-ID: <CAN9FmivnSq-AmNC32EEy__vmB+GSBn2YxSy-jBHZyiDf3ymgoA@mail.gmail.com>
Subject: Comment about unstable DSA devicetree binding in marvell.txt
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm looking at using mv88e6xxx-mdio-external for the external MDIO
bus to communicate with a PHY.

I couldn't help but notice the comment about the devicetree binding
being unstable in Documentation/devicetree/bindings/net/dsa/marvell.txt:

"WARNING: This binding is currently unstable. Do not program it into a
FLASH never to be changed again. Once this binding is stable, this
warning will be removed."

Any update on this, is marvell.txt still considered unstable?

Best Regards,
Andreas Svensson
