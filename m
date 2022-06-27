Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D9855D6DB
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbiF0OZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 10:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbiF0OZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 10:25:52 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B151F13F1C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 07:25:50 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id fi2so19515199ejb.9
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 07:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=y/WwzOufdV8bFjC2XhKxeIddPBCZMNKZVHLfMOMvj6I=;
        b=A5kE7UjrmtXz2xeANrDNBqyoHMNa0d9srprppBqBpT2sGT4jQfM+6Rynf/Jb87faGq
         alOv2hWr3UT1euUYjjDHIT67Q07vyxucwqUqHfBGUr6AbZC/SCZ73pjdde9BQtFYOASo
         /18bLCGPEH5Avo2jgIST4nrp/gCacNbMkyr/0Pet1ojIDahEK1oBGAT4GOP6edLGhkr5
         ImsUnkYfyBaDlYYT4rdv0IbjTry/IUxac/JUB8ev/Ox7o45NgRGWCC9pVTEo61A4bqL8
         7IB8WfwNgzoTuuSBTeNJyUN9oB5jdE7xUbGCGbikxZ0P2bQCDLpT/jh6J4H9X92XpEIY
         vLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=y/WwzOufdV8bFjC2XhKxeIddPBCZMNKZVHLfMOMvj6I=;
        b=awtJf2VO2n3mRa3Hr8NQ4H/vhagFaPn9cH8d2Bdzj9TIha9y5Y07yv2eSedcd/jLe1
         auyI4rj1GmoHfUdQiBvd6XhbbIVTrE+n3S//tLa7Z8VG6Inyb0SuqVQaySK5Ze4QYmhh
         zJje4KITEY/yay++ofFOyniJn1seooW66DO+scWA5L4JBpUtysfkljBupktr+yCLEIRe
         8jOvmuXZUp7C810kJO+/SbkGvXPV+K1GPhAUeVy1az9DtP9fV0VAtLrOK1NHZRW9t3ss
         9LwYpRn5X8MNaAxCdoPzHYeti7RuVMVlV/bKm4Vy4G8qXOL11vltmVTLDLRU/SpZV0Iw
         Z5Xg==
X-Gm-Message-State: AJIora+eDo6TPUcnr+X2mTnH9qRouJLJfTvNnjQS8LkPmHheaDH8QBDz
        TOmq0dQZ/ivAsRflWjnVK7Rsv3h0xESt34aY3rk=
X-Google-Smtp-Source: AGRyM1uhVRscYRqT8BpHRQKfB4OA4I7TrNhQvNQEInn11WsuYtOtE3TnFLs5b+xU1iqkuRszlckLPl9PIcjscqCwBnk=
X-Received: by 2002:a17:906:5256:b0:711:ee4d:fbe4 with SMTP id
 y22-20020a170906525600b00711ee4dfbe4mr13082306ejm.312.1656339949222; Mon, 27
 Jun 2022 07:25:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: drtracywilliams89@gmail.com
Sender: salifnaba@gmail.com
Received: by 2002:a54:2c51:0:0:0:0:0 with HTTP; Mon, 27 Jun 2022 07:25:48
 -0700 (PDT)
From:   "Dr. Tracy Williams" <tracy0wiliams@gmail.com>
Date:   Mon, 27 Jun 2022 07:25:48 -0700
X-Google-Sender-Auth: f7Pt2XvOlRxFzjU0HWr1YZELdg0
Message-ID: <CAJ7ceGfs3Yr5svVd7oAmOy0tHoTfV1jwsxbvCqogFP=s0KZZOw@mail.gmail.com>
Subject: From Dr. Tracy Williams.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear,

how are you today,I hope you are doing great. It is my great pleasure
to contact you,I want to make a new and special friend,I hope you
don't mind. My name is Tracy Williams

from the United States, Am a french and English nationality. I will
give you pictures and more details about my self as soon as i hear
from you in my email account bellow,
Here is my email address; drtracywilliams89@gmail.com


Please send your reply to my PRIVATE  mail box.
Thanks,

Tracy Williams.
