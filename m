Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3899E536DC2
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 18:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbiE1Q3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 12:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiE1Q3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 12:29:00 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCD9632D
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 09:28:59 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-300312ba5e2so74920137b3.0
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 09:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=bxqM7UDjEo2Oo2VoBTkzidoEthbn8OzzAhqUINKskM6Pz3vRjPw7MCUoxXQm14vSbb
         peQuJBRWA2NOwYqdowtgRHplmN7z+ZNEioGgyDd6OUlLefn5bav0q45lG3sgzbZPYgjR
         1FUumzDsR/puwcZ4edGvbQYKD/oO1tYgxq53ViId0988KN+2VRn2FTrqPAIO9tldDgMZ
         K48Lw21c5Yx8Q4ppS1ThpqVebCtsdBS6PZVVOfRDMklzZhNpKVfOr29CDv19SNwPkzUJ
         USXuyEHE4iAqBuDF1cfcgHdCzBbEZRemSvpAPuFtOUpC2J7W2waP4SJsJgn12QpEaHWx
         xSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=npObNX2O7oQCdKVJ8pimJ4CCNJ7oR8HY4i0gIvU7LSgF4JKRIY3n373ZdaUjm7VPmI
         BkPbq3OIETK0pdAFoZpOcTanF1ebSuKt47/ZKWHrqhoWDxCxVTPF+fFQQo/68el5fD6H
         8z8NcJF3WvIJr6DBfAVum0rE6sjnIhV+jyT1RqOx5PjeeHYm/oMdLBhySuLeiyUKjyi0
         DjS0IADz9R+mlmfX4Vo1X6TKVWzEEHsgbTR3lcU1LZLXksL8Y5/JTXQtSdINMassjoAn
         ZL8gwRhNC+cjwMp0KzibMY7vilHxSTq8GZ4Ufpzu2D1yNVuaqv3+fsYXdsKEUw+5YZGJ
         97lQ==
X-Gm-Message-State: AOAM531yWFOIREAq+ED0R0hHLvttWcIHTOhdDytO2f3lNSohb/IOYtSt
        S0dtpYFPGGqC5yQWouxBHjzi80l4/HkrNStvJgE=
X-Google-Smtp-Source: ABdhPJzDD3hZLzQuQxzFPjD43gFjQU/bJZOqLvH7eF3JxsecItU7lUOyMxZuW+qZ6k0GKK/e1dZEVuxzdRhBBe9lqgo=
X-Received: by 2002:a81:7507:0:b0:304:c651:8a88 with SMTP id
 q7-20020a817507000000b00304c6518a88mr11769714ywc.448.1653755338753; Sat, 28
 May 2022 09:28:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:2b07:0:0:0:0 with HTTP; Sat, 28 May 2022 09:28:58
 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   raouda yaye <raoudayaye@gmail.com>
Date:   Sat, 28 May 2022 17:28:58 +0100
Message-ID: <CACysfhe5Sr7Bv9q18Ndqk10s30mK3U97fdE1t+DhDYQ71fAwEQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1132 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5002]
        *  1.0 HK_RANDOM_FROM From username looks random
        *  1.0 HK_RANDOM_ENVFROM Envelope sender username looks random
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [raoudayaye[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidnelson7702626[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
