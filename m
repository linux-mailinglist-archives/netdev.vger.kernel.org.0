Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C728A45387A
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhKPR3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbhKPR3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 12:29:41 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DD2C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 09:26:44 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id w15so21222263ill.2
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 09:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=aiszIOjFGZ+Ed+0/vsAzYgPCATpDsN4yLoVBIGviy3c0tZUHSNQRyxKisRmb8CRVGR
         yF9YfziejLyZMNEtH4fWHj5ii/PSeTtHvnrJ8SMJnIl1jB1zC//1WA5T+jJxh9Px2srT
         +SLyvdRDw9sM/psC3PdnSKjNHpj59D1OrSh0OJ4nvnhAtY9A3mbECYGwmmYcxXvor25r
         co0onzRQGV/sZYblautz/ZFgHHV69b0evg6d9ejzgBU9n9HlayT6bXW8mYJIGl643eaT
         TU4CpfOKtNShj1/WEPqGTVesDDgV2TeWjGf0tVnfXifIcfY4ZNbn5vsDPwNg63oC0gvt
         S1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=v4YaUvezsQFpQVXNB0pj+/l8hJ5HuKMZ53CuLwzG5eSuz8dBt7Zvk9pmb4lUkS6pu+
         vUK+GYHdK4rbGwI4KosoSlkzl+mA+pydoqxb1XZp9H8D8bAewbVpbrLvmEObslQbmY/7
         CppXJZ13pPgb0DN0DuLWTSi/ktClShD85HWodWSbHShLFkT6QfZPla2lZ9x2/gOjvfHn
         0IeTGplsNNqc51Qzgxpo8/2JcS+QQ+sZy95HbTJ3afZxVdG922R26NWjsVpfN0kcVqBa
         AzBcnV3HGNM6uNwj51PYap4sYlB000J3utuOxCnHoRvyYO7S0HReSamkmh6N89nfrknv
         nz0A==
X-Gm-Message-State: AOAM531bslHShxJLpKjVtZmm7zPojbnOGQvOGhwvNR6VvLiOvebhWnfa
        KLNw6nR9I+MvXL8S9cjXjodF3j3YYjbABOTmkBQ=
X-Google-Smtp-Source: ABdhPJxQuj3ZKIwE/bbxhhBBN6k+t85rkppUOUT6Zrq+JyuL7uPuDy9/fnzNmrHzO1gN5oH8a10P/i9LpCG19ClFxHY=
X-Received: by 2002:a92:7607:: with SMTP id r7mr6088981ilc.317.1637083604068;
 Tue, 16 Nov 2021 09:26:44 -0800 (PST)
MIME-Version: 1.0
Sender: residonn000@gmail.com
Received: by 2002:a5d:8988:0:0:0:0:0 with HTTP; Tue, 16 Nov 2021 09:26:43
 -0800 (PST)
From:   "t::" <mnclbrwn@gmail.com>
Date:   Tue, 16 Nov 2021 17:26:43 +0000
X-Google-Sender-Auth: oQ16HHRY4JVLnG3pNknWVC5lnu8
Message-ID: <CAA2rHC0faPvcRr4de5qWUS7STA3YCvE=vg0SLX39SHaMCa-HdQ@mail.gmail.com>
Subject: =?UTF-8?B?6K+36Zeu5L2g5pS25Yiw5oiR5Y+R57uZ5L2g55qE56ys5LiA5p2h5L+h5oGv5LqG5ZCX?=
        =?UTF-8?B?77yfIFlvdSBzcGVhayBFbmdsaXNoID8gLi4uLg==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


