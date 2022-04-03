Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 819BD4F0CAE
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 23:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356933AbiDCV6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 17:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbiDCV6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 17:58:24 -0400
Received: from mta-out-04.alice.it (mta-out-04.alice.it [217.169.118.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBD8639BA2
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 14:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alice.it; s=20211207; t=1649022987; 
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        h=Reply-To:From:To:Date:Message-ID:MIME-Version;
        b=SDIyDcDf3WTWTGzcrPlxKM4PIs4C3hp9XUZKFosawwFRVOc2TgSxaRd6kNOYy73DMfSYRNt7Z8L9ufT3uf/oposcjtenjB+fVrHhtORwi3EfEDnLasa+HjLaWqthzaeZQWPE6rLsJq0s7VOTlEm/KWpMz6pwjC5STn1eMeT9/wrP0Jj7fWgAcQ7ImlJlbQnzc+VB3Gr21oUF5787YSYSwWKdsUgoHW8C8DbX7kIYF32wYlDbdQAhGs2kdYdicGjWZcPd8V4zgkZeXU/SJ4A9Aw1G/hU/gpwDla2Th92+eweOAd9AxNzY1k+UKHSn3ZSnXsW2OncYyAXgdrdAK1VA2w==
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgedvvddrudejuddgtdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvffgnffgvefqoffkvfetnffktedpqfgfvfenuceurghilhhouhhtmecufedtudenucfgmhhpthihuchsuhgsjhgvtghtucdluddtmdengfhmphhthicusghougihucdlhedtmdenucfjughrpehrhffvfffkggestddtfedttddttdenucfhrhhomhephggvuchhrghvvgcurghnuchofhhfvghruchtohcuihhnvhgvshhtuchinhcuhihouhhrucgtohhunhhtrhihuchunhguvghrucgruchjohhinhhtuchvvghnthhurhgvuchprghrthhnvghrshhhihhpuchplhgvrghsvgcurhgvphhlhicufhhorhcumhhorhgvucguvghtrghilhhsuceofhgpphgvnhhnrgesrghlihgtvgdrihhtqeenucggtffrrghtthgvrhhnpeehjeetgefhleetiedtkeelfffgjeeugeegleekueffgfegtdekkeeifedvvdffteenucfkphepudejiedrvddvjedrvdegvddrudeltdenucevlhhushhtvghrufhiiigvpeeiudefnecurfgrrhgrmhephhgvlhhopegrlhhitggvrdhithdpihhnvghtpedujeeirddvvdejrddvgedvrdduledtpdhmrghilhhfrhhomhepfhgpphgvnhhnrgesrghlihgtvgdrihhtpdhnsggprhgtphhtthhopedupdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-RazorGate-Vade-Verdict: clean 60
X-RazorGate-Vade-Classification: clean
Received: from alice.it (176.227.242.190) by mta-out-04.alice.it (5.8.807.04) (authenticated as f_penna@alice.it)
        id 623DC2DC0108BB87 for netdev@vger.kernel.org; Sun, 3 Apr 2022 23:56:23 +0200
Reply-To: dougfield20@inbox.lv
From:   We have an offer to invest in your country under a
         joint venture partnership please reply for more
         details <f_penna@alice.it>
To:     netdev@vger.kernel.org
Date:   03 Apr 2022 14:56:22 -0700
Message-ID: <20220403145622.7AF692AAD1CA2B48@alice.it>
MIME-Version: 1.0
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,BODY_EMPTY,
        DKIM_INVALID,DKIM_SIGNED,EMPTY_MESSAGE,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,MISSING_SUBJECT,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_L4,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.7 RCVD_IN_DNSWL_LOW RBL: Sender listed at https://www.dnswl.org/,
        *       low trust
        *      [217.169.118.10 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4996]
        *  1.7 RCVD_IN_MSPIKE_L4 RBL: Bad reputation (-4)
        *      [217.169.118.10 listed in bl.mailspike.net]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dougfield20[at]inbox.lv]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [f_penna[at]alice.it]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 RCVD_IN_MSPIKE_BL Mailspike blacklisted
        *  1.8 MISSING_SUBJECT Missing Subject: header
        *  2.3 EMPTY_MESSAGE Message appears to have no textual parts and no
        *      Subject: text
        *  0.1 DKIM_INVALID DKIM or DK signature exists, but is not valid
        *  0.0 BODY_EMPTY No body text in message
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

