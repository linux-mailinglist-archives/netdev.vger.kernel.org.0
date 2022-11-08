Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25334621F6F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 23:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiKHWpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 17:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiKHWpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 17:45:10 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7687860681
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:45:09 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id k67so15072903vsk.2
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 14:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=Yt5rRfVabIIG6bDlL3VIAhyFj0GrFsnnkekRIYwKC1gYvQXb4O7i0xxGeYE+skm7wM
         JIORBS4tl825Tna6QeShM7CaSIJQ6v0x2NkrJO6qq9qPNaf1Pkaos/irF7heK2mgEOxN
         BA7bhaevEnpICiluf1f7mOvBKfTVyaOpYIL7jgfNHy5WR3702jCKtZmXBsvo7mRFXH3z
         P3+8pVF+Vy/JyI6ud9reGANQrxzcKr0gVvlmm2P693Uy2Fsqun2HKghjnZ6AiPkcBAW0
         uI3bsnVyhlQPZdPOsdXMTDBln5rVcHvmfHA8T535V60kvycodxySZfXfOhUl82td9L5+
         ciag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=Elwyyz9IyCTWTJT3D1OJrfSnb4S5+zrV7iUToCNDQ+PBdpEYrsmZBLH+/9axykoE1m
         HhQClfVaapW8/aZYvzNZ90IiNdv3pxXgAfGq8dY1jBCj6Vxzp8ridM193w1uB8+TYo+y
         jt717wKThceVzi3YPxNJmg3tiza2lwhHnlUWsopleEti5/HaM2uX8vvsU1S9cG+K7aPS
         wjWi01sQJh+jd8SBNjNZFIy4JAozJ/JvNt9lvBqDqDdhi962FEgArRd9Wf+jE6Zs/Vdg
         0PAkNHbiqFaJftc019aV0Eh2Xkj0sAZWGlfm/0VYGmiZJItCl1Fdjij4uvqdyju45JqK
         cxug==
X-Gm-Message-State: ACrzQf2Q+yfEm5hDvU0JsWR4RS+cX7HP9XbvzmWb8hsAbRDTtjErmc/y
        MwATrtEOuxKa18cf8eBSWj7JI9HCjEuP0EiXhiM=
X-Google-Smtp-Source: AMsMyM7guuUPz4WAQR+a2s2mWIS418VzP+ueJLxZ0z/LsxsPyrGiHGRDLoKoCXypI0cj3yyr+9Jf1EzaiRrofiCbmGQ=
X-Received: by 2002:a05:6102:815:b0:3aa:1030:f5bf with SMTP id
 g21-20020a056102081500b003aa1030f5bfmr31890373vsb.39.1667947508611; Tue, 08
 Nov 2022 14:45:08 -0800 (PST)
MIME-Version: 1.0
Sender: samireotokou599@gmail.com
Received: by 2002:a59:54e:0:b0:32a:2a57:21e4 with HTTP; Tue, 8 Nov 2022
 14:45:08 -0800 (PST)
From:   John Kumor <owo219903@gmail.com>
Date:   Tue, 8 Nov 2022 22:45:08 +0000
X-Google-Sender-Auth: UknI8iJsYSlWNvoVTVdOq-cK6YY
Message-ID: <CAFdUHwVmrb4Rnu-yWERogJ0nV86TF7ioOtEKO+0oP1Rrz34bkg@mail.gmail.com>
Subject: This is very urgent.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
