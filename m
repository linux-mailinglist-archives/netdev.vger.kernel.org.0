Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4392C662124
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbjAIJNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbjAIJMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:12:13 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E07EBE26
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 01:08:55 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id z5so6382296wrt.6
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 01:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ySav9Bwf7eUcjJDjyl8LNzlx8CQeDpJMWO+9GzDKsMs=;
        b=loJEKRBc+ooZRediBKvPji/o7zWGOADwBBrzGbjf37uQ1kXMFxyvNzRCrMAfwOPmS3
         QanmAC51m9gqkA1x6KzL6KYJEvyCoxFFjOwRmZ7sFKYP66DuDj2QqbiXuKIWvWqCK02u
         g3RlYDFL1w7KZaTMTA+LXEjvOOgtH2vPGU52bJnw+OpB416Dx3PFXlOBfQe7vkD/7I7T
         A842JLL6qVWNUKifcstILAIXQ1NQvWDU7RA9/Srw1iEJ/+9eHkOuWxxYv3BQKGUarAf1
         pO5kI/AeDri5l4KFgmJFqd1wKHyaIpXAMWh76/y8z1ytH5j96wCcwxRrfAcLfVOF95NH
         PjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ySav9Bwf7eUcjJDjyl8LNzlx8CQeDpJMWO+9GzDKsMs=;
        b=5guMyZLAc+RzpQbUOkJgZufaSZOcgracRoSp+AEtrUcyv+SKciUJ/AMbNfae5r56QY
         sYM/gz1762P1tVPgKz1jk3IOZnAIDJY4I2lL5uPvGR+LeJslL7xmEMoaRLVLrvCehtsV
         IJpOwdbvsC04qY2NcwLRyvj/nBCahYeE8U5S/pAoScq4hLW8dO9CAhn4gn+p03FkR7kN
         vT/VTO1SggKlCaJE5p9MadUPG37LTiyoC6abIM+J1Qd5cIRnwDaWEY/1LuIbawI2Wp3b
         W5KvX2x8pYKCOiMTXk+prfppKKcBJUYxZ6CJig8w7SVHsnY6A3CHJ78sMowpnVBFwcTl
         ViFg==
X-Gm-Message-State: AFqh2kpMqj8RfnPaJLaTPjS3Z9ZEuSwytEPEhIoCmQVUzB9i0Ll2AF5f
        098PeGBABGf9IqE1aUd0LaINmAtaK6aomec+HS8=
X-Google-Smtp-Source: AMrXdXtRWkXYgr2ma4Cc0D3yGLHBteaSiGLTicjPVLkLFQGKm51OUW6rJojKmuGKZxiIs4DxPqXhDhLjhsbZtv+SkWE=
X-Received: by 2002:a5d:688c:0:b0:2bb:329c:8b83 with SMTP id
 h12-20020a5d688c000000b002bb329c8b83mr335909wru.649.1673255333598; Mon, 09
 Jan 2023 01:08:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:6c6f:0:0:0:0:0 with HTTP; Mon, 9 Jan 2023 01:08:52 -0800 (PST)
Reply-To: christharmonyloanfund@gmail.com
From:   "Mr. Christ Harmony" <daphinekimuli@gmail.com>
Date:   Mon, 9 Jan 2023 01:08:52 -0800
Message-ID: <CABRxmTzE+oC=02XTOx2a9H2Vx9ELH5NX=Pz9SEe-GhjFzYXfSQ@mail.gmail.com>
Subject: URGENT LOAN OFFER
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FORM_SHORT,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_FILL_THIS_FORM_SHORT,
        T_HK_NAME_FM_MR_MRS,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:436 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5487]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [daphinekimuli[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.3 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.0 T_FILL_THIS_FORM_SHORT Fill in a short form with personal
        *      information
        *  0.0 MONEY_FORM_SHORT Lots of money if you fill out a short form
        *  2.7 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
DO YOU NEED A PERSONAL LOAN, OR BUSINESS LOAN, LOAN OF $5000 to
$90,000,000.00 IN DOLLARS OR EURO? IF YES US CONTACT VIA EMAIL:
christharmonyloanfund@gmail.com WITH THE BELOW INFO.

Your fullName: ...
Amount needed:...
Duration: ..
Phone: ....
Country: ..
contact via: christharmonyloanfund@gmail.com
