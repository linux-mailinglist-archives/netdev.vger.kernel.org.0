Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890435AB582
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbiIBPlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 11:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbiIBPlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 11:41:12 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2518717A9E
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 08:29:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mj6so2377502pjb.1
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 08:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=B/bzVap7w2nbpPLUVaGrgo7Id2TJpqaHDpbbBhcEalA=;
        b=ZSgi5pkEhgNCK5OmWB6vLIgEjkIh1wKQb1Ia4t37ic7H20fGG4xNy8FqM4j6ykghdd
         z+gs8WP+QTi7R4sNRXhd7+xqqYuipNTcmZ/2B4fkpRr6hlupH3RbYAc9RwO1XxQ4ek7L
         iuaOKo0GL8HdagABQqf3wgsAaaJdfPAThX6jf4PYw9OnzwI2SgHWF2NqToqUMk9CF+Hx
         pREa9KQ6uiERUvU+erN179I3ckuV+Xr1VfLuVPunjcg6CvkkRIkxbNjImv9jhsyv8EJD
         8QL+4ayLJtHnAzYpM9zh3daCIWI+gvfiqc6EK82HORFfcU3PQTCZ4XNWeQM+H8hzVEB4
         Fu2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=B/bzVap7w2nbpPLUVaGrgo7Id2TJpqaHDpbbBhcEalA=;
        b=p83/nL6sh5rr19O/ADlLhfgPECmeDbShHmTh6oDo3IKyicwHJiCGULb4sqEBVitHni
         B3xzszBvl88GhSKg9tlIpM/0H/9j9jT87kqn/dLRY3STsEHV+Mv/225HsePKjtSYuPBN
         5gMthgflhLEgYSRi0knATMsSAFXZldqcNrNbJ4+M4KXhlPK/a1j6vGnzUfh3MPt1Bs35
         rhTIYemMFdO5d5LW5rYw5M+7SSiLSwUeTXi0AEOQLc80EwUMBKN8dCz/Hlv5773d06IM
         +giYAIxn/3uI+dV/Vx/vV/32mvvvnUBEH6lTvpXA9Hc92EymqXi7fMrOK2JnWmGGL06h
         jfFw==
X-Gm-Message-State: ACgBeo36SJDxV9Q76X+Rb3BN162GksWj35lndPR9lYvrusXP/Wu5IiS3
        PKGJGJw+CR7Yd/A6IYMvUvV78rYvz+UTkRki9KE=
X-Google-Smtp-Source: AA6agR5xsjijUR9Zs5a/DWqW7F3XZ2IYgITX23ekFNCjMxtUg5k6XE07FE3hx0hTCYUSJgT6FtwwcLwEuMu3gjyVdUc=
X-Received: by 2002:a17:902:cf11:b0:172:6437:412d with SMTP id
 i17-20020a170902cf1100b001726437412dmr36145720plg.10.1662132542203; Fri, 02
 Sep 2022 08:29:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a21:3988:b0:8e:d5a9:6ad0 with HTTP; Fri, 2 Sep 2022
 08:29:01 -0700 (PDT)
Reply-To: mariandavies73@gmail.com
From:   Marian Davies <cj34024319@gmail.com>
Date:   Fri, 2 Sep 2022 15:29:01 +0000
Message-ID: <CAK14DJdi5bYREOHS+ij6kLsuavK5REpub6msd9U_doGvGvoq8A@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4994]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cj34024319[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mariandavies73[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [cj34024319[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello
