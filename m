Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DDB4C22E3
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 05:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiBXEHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 23:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiBXEHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 23:07:31 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4D99FF2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:07:01 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id l25-20020a9d7a99000000b005af173a2875so517330otn.2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 20:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/WC7HTRELV/OnLen1c2rD72XeE/g93MkRb1iUbcoOPo=;
        b=S9yHies20Gv8cQ7ZLv5OkdnvQhOMXJkWF/afW2my0H6lpwhLaxxmi6ymehhqxsXDis
         Bx0RIUPhkLAs8ujrvzWNpGyP7/9nAOu60CDWdHzyrQdsQEX7hFDVJcEPKSbVGg9Fobt+
         E7ADdhoC6V7oaIrmdBPBjS5GIjE8pZFFL6vz3LilgREPza9KNFucBaeKxyp2EMhBdRqQ
         dcblVkysqJo4KBwdYx6Af+NLl7dtRu5tFyFayRwhLlzvlyRpESxMF5AUJWeQl0aDF1vv
         7Eq2+fjA3c+c0x3TAWNSJUsqEH/Rx9GkmAy8qJs5jYaePQICbC/8IdRTIWAcWqTHkgQF
         oIFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/WC7HTRELV/OnLen1c2rD72XeE/g93MkRb1iUbcoOPo=;
        b=J7C02aGHv+7T0P9ouD3djdOzQ+EQHcGzD3gCi2qfplUo02Ku4zbFXpHtoJT7QYd1bj
         Po5XwV63egWTTLY9Oqes8ac2PMWfPGdgjJwzGBeDZf5vW1mSAgvwoLrVZM2h6vBKSLhf
         rT+UDYvb3JEhOsMYFYoZ6YYmV1TkrIDtZYHboBHNgBUOBkQud+bP8gP/3XtpBnmrNJ7m
         epwnXS/cbRb8KzGi3BpQptKqUvJcmA8Kj/woSdGyWPdQlrZfps3o2Q0Gl0VRaEpF0uk/
         94XLRbbCrRXi/z1KX1H8dGu4Al/2bkQZKHw3wmy7D2JyIvpTbEcv31fHJHJTqooJ0h/W
         duJQ==
X-Gm-Message-State: AOAM530kG+xAQfFJM013QV6wQHFbpUidoVnUzY57X6rJ6Caki8N2Fx5k
        54d0WMBsaJptY55GWiExbfgSnjASKwYRV/gkvAI=
X-Google-Smtp-Source: ABdhPJxcxoR8Ep8kuBIcd3djrUe7tk6LZk7kf9ruWuKkk8JQOy1L2Bz7jCRtV0W+7TApFwbKpOU8nRDOGCsqylneo24=
X-Received: by 2002:a05:6830:5:b0:5af:7ed5:8f64 with SMTP id
 c5-20020a056830000500b005af7ed58f64mr273491otp.257.1645675621232; Wed, 23 Feb
 2022 20:07:01 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a8a:354:0:0:0:0:0 with HTTP; Wed, 23 Feb 2022 20:07:00 -0800 (PST)
Reply-To: j33ciss@hotmail.com
From:   Justin Cisse <ays028a@gmail.com>
Date:   Thu, 24 Feb 2022 05:07:00 +0100
Message-ID: <CAGQvKQE35QWRy0s1NG0G9TYt7PSi+04hoPdfNHmye8GOqnwEJQ@mail.gmail.com>
Subject: TT:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
I seek your partnership in a transaction business which will benefit
both of us, detail will be disclosed to you upon response.

Best regards
Mr. Justin.
