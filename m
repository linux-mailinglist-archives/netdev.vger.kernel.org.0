Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596F259C44E
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiHVQnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiHVQnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:43:07 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA581CFC7;
        Mon, 22 Aug 2022 09:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1661186571;
        bh=ZVl1qlViPFyyPVRrdfleq6nZ/0wekuHB7Qpbgn+2QjY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=lAylSnfapnkH8pNI7uW4OiDdCs1rYVRP7aIOBUJWKk+EiSbfGZYRuOYOB1cuuVpCL
         2tkQ9Bug0A0h6E5juquMoxf0T+7E60Bo7lOCw01f31setEtQBk8B65H6kMm92i7Hcl
         0HaTpxQmjAYtMneHhSZmtNofgZhlqYUKD9fTQsC8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.225.169] ([157.180.225.169]) by web-mail.gmx.net
 (3c-app-gmx-bap06.server.lan [172.19.172.76]) (via HTTP); Mon, 22 Aug 2022
 18:42:51 +0200
MIME-Version: 1.0
Message-ID: <trinity-64c5eed8-8b6b-4b33-9204-89aff4fce7db-1661186571606@3c-app-gmx-bap06>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Aw: Re: help for driver porting - missing member preset_chandef in
 struct wireless_dev
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 22 Aug 2022 18:42:51 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <b081ef6eb978070740f31f48a1f4be1807f51168.camel@sipsolutions.net>
References: <trinity-de687d18-b2a2-4cde-9383-a4d6ddba6a77-1661177057496@3c-app-gmx-bap06>
 <b081ef6eb978070740f31f48a1f4be1807f51168.camel@sipsolutions.net>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:T+03bF53OLk4H19cqWbdFke+oWSDFdJNRdlV2zJMLb2YEBbm8m+/tOmYqXdW00IIE0LBo
 /5ZNgLC/6lrkTRNu4d1cXxSss+2VKvCy5ohtByasaRr9G4GMHjX+LLnCTDyvfawRZs7FSOyLrr7E
 k7J+Sbb5nOFMmt0NWZKe96ak/BpCy8co9bUOjlRBzJ5AxTGezTAS+0tFI+rcFev5iaVjLDa/s61s
 s8UdOSFl0WL9Szdl2eAal6KjLkA9CKcE8CWRwv+IhEOgOUQbWf302byWixcHXLbp2ToLJ8CvSazn
 I8=
X-UI-Out-Filterresults: notjunk:1;V03:K0:YpRSICXOYvA=:tdl8H8FeAKQqrnyrWiHouc
 6cqGT1LkYVrU729A3GYamO0LI0JKTlLvoM78CGlg1PRFh+Y7iGvsVQZ8ZrU5atN743ecHu7J5
 Mk2CWxYhiMJLhay6dnC2D51MlKWM4WLK085aTTJen8hkFJToDknlhAcpDwSmoub0DLJ3t3HAS
 VyOiiNZLvpaIPkK0+zzZm6It9DNt7HXVY26/BaAq4QesIKNohA7OFl/tTdL16IkSNkX+F7Z/b
 GPaGCqzn7AZzT9U1hXd8A1qPSeny6Ja2ehO+5R3qQ39eUb5YszSkHQK8c8B7BhwblPLs9yEy+
 vL8+vxxay+hEn1xbqwFdLsQq/kYae6SQOQvEw6ofNKM4L3H8S4h9+BiAUstChwHZfOAOnutVY
 XGoV87hHidxq/YUKWDhZYzbLjCaSWFC2VuBuTL3RLd4gMUIy7Zrkrk9BEtcamYZPnC3QGDCzg
 2t9WpWq//U0pTAoA7iQh22BALnj6LTHhbvj6/koTw1hW2N3q1FUthPSzvlHvTO09wuJDlBFUL
 9ORjmsYx826Z3rCUwSlgtGKzeflmuf9Ocgs832S/LClqCjRgJk2N2tbCck84jtGa730LhwOUV
 fQnVhjtIaJJ0avehxCFzx9WDUENa/gZSw3LzO/ZxOzEmq7E8H8HqTjaCdADZplcul0W06Eiph
 8lyltVn+WInNGQdQJZBZpy1Df+Ok45o6u0RMY1TvFeuh9s/o9YesRJY3cJb9J8hTAPG8ITESj
 RwpA9ZG7BAPn0k8nuet0sJV7E2WHQkatcCXOn9aGJERiLj3LMK0Z4X36O5tvgHt70xd5MP5A+
 6MQT3yW
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Montag, 22. August 2022 um 17:02 Uhr
> Von: "Johannes Berg" <johannes@sipsolutions.net>

> Yes. Make sure the driver doesn't access it, it should get stuff through
> other APIs.

thanks for response, commented out the use of the member and the wdev assignment as it was then unused
can you tell me which api-call this should be?
i just want to make sure this is really done as i up-ported the driver from 4.9, so if the api-call was introduced later it is maybe missing.

> johannes

regards Frank
