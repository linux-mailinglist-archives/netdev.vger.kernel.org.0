Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8669C2B5
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 22:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjBSV1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 16:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbjBSV1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 16:27:16 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F8917153
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 13:27:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id e13so1349089pjt.4
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 13:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XZVkFn3YwdxEdThkVHM6Q9Cxc1dE09qwtEAvH/ySM1g=;
        b=f42L9u/daWudjduMWNmX+VxJgADVnS12ocoZ2H34THlILxR9PaRVXCx6XQEb9OOaNE
         swtAH9MSOqymU9Fa16OdA/4EHfy+qLxkJ5cpkh9gV3CASg3Vcw/T8Cuqp2yiCN06vAX3
         JJlIHkpoal05FoyOLqTe6D4shJ5WmHD964x71+HTM8Eild6LtZK6ANtauLVsZMp179z5
         IM05ZEMWM+vVBQAAXBdAVwbdN5UpxUNMtTHRrR0C7O2xfl4dZ3/g/qIwXuKyZBNqwikK
         j1TjW9fbIolQA6ifQb/yqs99LWVSPQE7JNF/TMOlIPWJ9Ud7Y7YYWBuxtkG2jgOsW0I8
         rZHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XZVkFn3YwdxEdThkVHM6Q9Cxc1dE09qwtEAvH/ySM1g=;
        b=WybBb15yY7593qHkITzdS+vFZ17RRSWHHgpXqCxXvrTamG5aHWZbGW129aBPFkao/E
         YmKm6Er1PX0HB4+t37/YWgAcfL42uZLxuDBLAPnShBYWrqQewuPCih68ifzINjWvxFEO
         sLsttNJpWaqTRvzX/osM9dI7mZ2FRuVdXwcIXoOOOTmAI4ETsk+/elH/K0S7xXNj/0kd
         ox6fFVoNcnNpB0AeMSY5/Kz+1neY2hEc5RMONE7ttrAUia4IJaby5ZtL+RVW99G5so5+
         zBoiDTI5j1ateuUUW7yXA8hz3NE4nbHm7q9pXNLI116SZdGLjWw+z+ls1vkYiWPhrE2K
         dpEQ==
X-Gm-Message-State: AO0yUKXx4zXjweTmxjOk0ZnfD0BKsjfU6N/fk9gSi8m+Yky3xMJLY5nD
        8TL01NNr2MuEMOK73R9Za8d4/3MzLbN5Xi4J/TA=
X-Google-Smtp-Source: AK7set9YyaKeHOnAtCCFlNj4lLtQvDXUGuK4pztMDA13+DRDMqFj3hwhWgkdg0b4um8fGS9UGSinsgKboa6yHqTiWOk=
X-Received: by 2002:a17:90b:3502:b0:232:cbf2:58a2 with SMTP id
 ls2-20020a17090b350200b00232cbf258a2mr2729111pjb.133.1676842035473; Sun, 19
 Feb 2023 13:27:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a11:4389:b0:40a:a094:5560 with HTTP; Sun, 19 Feb 2023
 13:27:15 -0800 (PST)
Reply-To: sgtkaylam28@gmail.com
From:   sgtkayla manthey <abdulhadiidrisabdulrazak@gmail.com>
Date:   Sun, 19 Feb 2023 21:27:15 +0000
Message-ID: <CANEyRey9mepceKT-YTXXGsStpnAg-GAQ2DWMYCYkyTC9b56Rmg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=6.0 required=5.0 tests=BAYES_80,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:102b listed in]
        [list.dnswl.org]
        *  2.0 BAYES_80 BODY: Bayes spam probability is 80 to 95%
        *      [score: 0.9253]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [sgtkaylam28[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [abdulhadiidrisabdulrazak[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
Please did you receive my previous letter? write me back
