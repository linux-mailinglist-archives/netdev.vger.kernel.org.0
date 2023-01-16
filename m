Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C048966BAB8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbjAPJn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjAPJm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:42:57 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67C14E86
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:41:59 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id f28so14071221qkh.10
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GmFirlKYMgbYub+fXXENCVSgGWnv6tB+3v2Wk5Fh5GU=;
        b=N4+37EcIVYqq1xo/sV4Tr85Eo7F+dK7xy939SKVSYvOMaGtLjJcJcSOb8un1aUoClO
         N4aCsA10P/sMZ2CN4cOjBSQman0V8CMeqlXBWb4n/fFdNnAqWA86NUVHgTqzfyYS5D/q
         Lsci2nCo2uGHS9PO4qsBwM27Y7tdHPFqolcsHGjPeqhQO+mb97opBcyC8dXfVt/OV76i
         V8NF+ruf/I073eUc3DBKnUPQi+ATkDD6MjBa6CRhf//BxVDe50/RwJtIZd0FHOMRqxM/
         7ihIxD3VOMwBZd4KH5h5eP/26tWJ1SvBcMT7Jv7fO4efbSpvPZA+vIOchlKmO8gfpy07
         nwjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GmFirlKYMgbYub+fXXENCVSgGWnv6tB+3v2Wk5Fh5GU=;
        b=pdCyFmN7PBJpcVch0/S+0w8ZYNoBmxzI1uQ99bTMqNRpfLFwGJJrlSNJtcyZFfexue
         dIyZfYyBRe6o0d+2kFXI5dgPv5rQE52XSKJkTE2QdU7j9rLkSpWkWdfTmODuuMWtvReS
         6Ti7L8+PwY34q+xzxH7Ruse3ITJR/9U44CcYE0YEBlwgF5nOlNgK1geYcbE4OcWX30cf
         MSszW24oJOwyGJssQNKI0/QZGFnxQCEGsK1VjCQrzJiLkYEjM863fI3Okifpkze0UgIP
         zxap7AduiVRAAmMeXuGu4up+7+FxLGCm1LZWKuJxIqYIpkT+OmKro6pHXz3qhJzKNBez
         2X9Q==
X-Gm-Message-State: AFqh2krGPwcXg/UnmsP8SgQoQ7EX33y+v0Mm+vo6F8pQi3n5aibPe7uR
        vmUQOGM3TwldefwUIcBFatT2gNZ+bsk/vlk+7aM=
X-Google-Smtp-Source: AMrXdXu8+cvvDdkpPBSfHF3KsQedToYOvx5VbjZ39VhEf79esPkGEm4MN3VnpQZ6LKGEzU6a40AkZHWXuL7mN3RKSNI=
X-Received: by 2002:a37:746:0:b0:706:4e95:1ecc with SMTP id
 67-20020a370746000000b007064e951eccmr289769qkh.189.1673862119040; Mon, 16 Jan
 2023 01:41:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6200:5a10:b0:4b6:fb18:3bf5 with HTTP; Mon, 16 Jan 2023
 01:41:58 -0800 (PST)
From:   hony well <honywell860@gmail.com>
Date:   Mon, 16 Jan 2023 10:41:58 +0100
Message-ID: <CAN7=mp55+TO3=JNPM3rmWWqOBTvKTYpimTUtxmBfL8kDUOQR=g@mail.gmail.com>
Subject: I am Hony well from United States I'm a widow.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_95,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'am Hony well from United States I'm 34 years old a widow. I' live
and work here in United States under
North Atlantic Treaty Organization- NATO. I have a son who is 7 years
old he lives and school in UK, he is been taken care by a caretaker
who look after him.

I'm interested in a serious relationship with a loving, caring and
honest man who I will spend the rest of my life with as I will
retire from the NATO. in 3 weeks time. I'm interested in a serious
relationship that will lead to marriage as I will be coming home in 3
weeks time to start a new life.


  lovely queen,
honywell860@gmail.com

=C2=A0+16782316019
