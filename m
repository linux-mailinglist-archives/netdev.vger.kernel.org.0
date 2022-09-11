Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2065B4C68
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 09:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiIKGzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 02:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiIKGzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 02:55:07 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916B61E3E6
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 23:55:06 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id v4so5394002pgi.10
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 23:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=B/bzVap7w2nbpPLUVaGrgo7Id2TJpqaHDpbbBhcEalA=;
        b=e407K0bLjiLxvg0lhYQ4/47iPzNzRs0KgiQEwvDYjXQ1RQBr02JLGxLl3bCiNj12mw
         HBU5eC44IHysEluHU7+WyZcHKlxy8UHFc46dECI7jFleIS635prk1lXSdbI3X1o0AQMF
         Pt09VY3i+tm1mst8t88H85malW0LwI3nt/iS42gASzW061U3ObKUsKPoBEL28qWmqpeD
         GGdev900tTpG0k3YXundT6GK1r6lqVzgy6yIz1AmBYPzAZUxjBCY2zhbI8dl5a/lBDqN
         0Q5DwxPtlfsi+rYlDK+LSI+2wJAjwpIQIUm+PmwWxPHdx63TQyIgYFmGbD3y/19SbRtH
         mRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=B/bzVap7w2nbpPLUVaGrgo7Id2TJpqaHDpbbBhcEalA=;
        b=cwyR1e3xiv9vLFbGzAsMUS+DmjuZekRlJe0b0ajshBjsxZwRbjnp0ttDRUFRlmZ3+P
         FZRQPqYgEK038SHmeedR0iQk5oTYvefpzZ3M92vNTx1XS32t2a813aiCQd72dpAoFdWL
         uygCyd12mOCzfdgnuIfec1GRSbW1S2STP4RabnhvI6en6CvF+ZnRnwbS9lEaBs/x3gTr
         dgTd9vDSfSLeAIRF2tczo168cqN5EuFR2k0CsEHEytH/z2YIa4fPANMigBit5N25cZUQ
         KP6Vq7892h7gvTzCYlfXtauzc/k9u9GppBd/Ec0EjlD9xXh+wGQSLlQnHnLADmMbzGQf
         446Q==
X-Gm-Message-State: ACgBeo0RWBBA3x051VM3cxzKG8q+JOgZhWtDGDwGPgShLR96aU3t5BYF
        G9RED/Vzgo4j99L6p5heW9k9cVVvCQCs9BNU5Zg=
X-Google-Smtp-Source: AA6agR4YZIxYwdKWlufYbX+QrB7Zrpw+w83vdcU2UCxh3eBmpfnBoORD32yxZhWaiHK7P3HQuuBzVdRRGo6sWgJKH34=
X-Received: by 2002:a63:ea05:0:b0:434:9dc1:a59f with SMTP id
 c5-20020a63ea05000000b004349dc1a59fmr19303713pgi.374.1662879305190; Sat, 10
 Sep 2022 23:55:05 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90b:1e03:0:0:0:0 with HTTP; Sat, 10 Sep 2022 23:55:04
 -0700 (PDT)
Reply-To: daviesmarian100@gmail.com
From:   Marian <afatchaoissa7@gmail.com>
Date:   Sun, 11 Sep 2022 06:55:04 +0000
Message-ID: <CALqa9Rb0gqytuPi+RV58gQ4WptAUaNM-XZLYFpqu7Fp6vGy6ZQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4919]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:533 listed in]
        [list.dnswl.org]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [daviesmarian100[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [afatchaoissa7[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [afatchaoissa7[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
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
