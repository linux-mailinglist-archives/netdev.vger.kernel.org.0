Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D92482C49
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 18:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiABRBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 12:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiABRBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 12:01:01 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2A2C061761
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 09:01:00 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id o185so66258942ybo.12
        for <netdev@vger.kernel.org>; Sun, 02 Jan 2022 09:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=k1eFEFzm2gbUkBLn/vGb2RFFDboOoQwRQSyFxZUo/6M=;
        b=WP2iFXaTifKPUpelOkxRWCaJUql2ZN+XVVWRqq3sFQmzBA6uolXlXNyRgBDuXNrdZ3
         aCxqdMSSe76sNDonDTDQy4kEtmRj6O9BpsQ/cAisj1G6hHntukVAlEb2Q8VKaZbgDtm7
         pqgVyArLr2twBB75twkR61rl2HNTJEVrYA7F5Behe3e7zsIFlLtF/DoC9KHa2yVLrwqG
         D6eIDJFXRFVv43GziczbhoJJ8KMrtqTQiHiZnAnO+dtp62qpFBK3PAjSnJQku+ct/fgb
         AvujhGGKAyGjo0EYEbB3OQDbg3SjNyx/PcVcqVlAU25GelCqVuwIWzbHJeyQ0JVzg2Ez
         rN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=k1eFEFzm2gbUkBLn/vGb2RFFDboOoQwRQSyFxZUo/6M=;
        b=ahG/S1NZ5rr3nW2Zs8WneS8DTg5cWyWgOH4TNpb7nrHmlEymFEWwykPGWNS4fJNXVJ
         mJmU4pjxl5hZTq8DgmuuLviWpesA52fCWdH2/VZyKSTmt7TX4zF27H2UxTUPiABqDEHx
         na1ZlIyaa12ubHIoArh9qIibCIXomYbCqLYnM/SRiNmDafhBsRgh3C19NCYPFSZiCkDj
         +S/GJ5E9hR9wVm+KZ9kIsN23KJVP73P9OP+LLrtbpISy6dQvllxTvDurRSsVh4XcADYt
         ERHPxDReVgq6P+sZ442kQn0KaXYY8xDXEaIwFhquy8jTnLsyqO4MsZO5Sh8H1kU+w9S5
         V91Q==
X-Gm-Message-State: AOAM531ZJSR2z7BoXiYkvuCfFCRgmNgFZXtl5XlDvxua7U7O2dDGI3m8
        Da0WHc17bV923D9E2R1xUTnZAajxUqEm9DAdGg==
X-Google-Smtp-Source: ABdhPJyPD0iTTKjWEj9PvzhEHh78DqkI6joJoaz8WudZAd7SCDWI8ZRWqGG633Axw+verpUy9v/bkE90ax5OJt6RBg0=
X-Received: by 2002:a25:f449:: with SMTP id p9mr51599736ybe.594.1641142860003;
 Sun, 02 Jan 2022 09:01:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7108:211:0:0:0:0 with HTTP; Sun, 2 Jan 2022 09:00:59
 -0800 (PST)
Reply-To: mr.luisfernando5050@gmail.com
From:   "Mr. Luis Fernando" <ellaemiantor2@gmail.com>
Date:   Sun, 2 Jan 2022 09:00:59 -0800
Message-ID: <CAHRdPM41Baj9p4NY_s_fbkWi_Wfn_HFnXzFvcW6snZvVt--Dww@mail.gmail.com>
Subject: GOOD DAY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQrmiJHmmK/ot6/mmJPmlq/Ct+i0ueWwlOWNl+WkmuWFiOeUnw0K5Zeo77yM5pyL5Y+L77yM
5oiR5Zyo5biD5Z+657qz5rOV57Si55qE6Z2e5rSy6IGU5ZCI6ZO26KGMIChCT0EpIOW3peS9nO+8
jOaIkeaDs+mAmui/hyBBVE0gVklTQSBDQVJEIOWwhuS4gOeslCAyNzUwDQrkuIfnvo7lhYPnmoTl
up/lvIPmrL7pobnovaznu5nmgqjvvIwwLjUwJSDlsIbpgILlkIjmgqjjgIIg5LiN5raJ5Y+K6aOO
6Zmp44CCDQogIOiuuOWkmumdnua0suaUv+WuouWIqeeUqCAoQk9BKSDpk7booYzlsIbotYTph5Hv
vIjmlL/lrqLmjqDlpLrkuobotoXov4cgNTANCuS6v+e+juWFg++8iei9rOenu+WIsOS7luS7rOea
hOWkluWbvei0puaIt++8jOS7luS7rOS5n+aHkuW+l+efpemBk+i9rOenu+S6huWkmuWwke+8jOWb
oOS4uui/meS6m+i1hOmHkeWxnuS6juKAnOWbveWutuKAnQ0K5Li65LuA5LmI5oiR6L+Y5Yaz5a6a
5oqK546w5Zyo6ZW/5pyf5L+d566h5Zyo5oiR5Lus6ZO26KGM55qEMjc1MOS4h+e+juWFg+WIhuW8
gO+8gSDmiJHlv4Xpobvnu5nkvaDmiYDmnInlv4XopoHnmoTmjIflr7zmlrnpkojvvIzov5nmoLfk
vaDlsLHkuI3kvJrniq/ku7vkvZXplJnor6/jgIINCuWmguaenOaCqOacieiDveWKm+WkhOeQhuS6
pOaYk++8jOivt+iBlOezu+aIkeS6huino+abtOWkmuivpuaDheOAgiDor7flm57lpI3miJHnmoTl
pIfnlKjnlLXlrZDpgq7ku7blnLDlnYAgKG1yLmx1aXNmZXJuYW5kbzUwNTBAZ21haWwuY29tKQ0K
TXIubHVpcyBGZXJuYW5kbw0KDQoNCg0KSSBhbSBNci5sdWlzIGZlcm5hbmRvDQpIaSBGcmllbmQg
SSB3b3JrIGluIFVuaXRlZCBCYW5rIGZvciBBZnJpY2EgKEJPQSkgaGVyZSBpbiBCVVJLSU5BIEZB
U08NCkkgd2FudHMgdG8gdHJhbnNmZXIgYW4gYWJhbmRvbmVkIHN1bSBvZiAyNy41IG1pbGxpb25z
IFVTRCB0byB5b3UNCnRocm91Z2ggQVRNIFZJU0EgQ0FSRCAuNTAlIHdpbGwgYmUgZm9yIHlvdS4g
Tm8gcmlzayBpbnZvbHZlZC4NClRoZSAoQk9BKSBiYW5rIHdhcyBiZWluZyB1c2VkIGJ5IG1hbnkg
QWZyaWNhbiBQb2xpdGljaWFucyB0byBkaXZlcnQNCmZ1bmRzICh0aGUgUG9saXRpY2lhbnMgbG9v
dGVkIG92ZXI1YmlsbGlvbiBVbml0ZWQgU3RhdGVzIGRvbGxhcnMpIHRvDQp0aGVpciBmb3JlaWdu
IGFjY291bnRzIGFuZCB0aGV5IGRpZCBOb3QgYm90aGVyIHRvIGtub3cgaG93IG11Y2ggd2FzDQp0
cmFuc2ZlcnJlZCBiZWNhdXNlIHRoZSBmdW5kcyBiZWxvbmdlZCB0byB0aGUgJ1N0YXRlJyB0aGF0
IGlzIHdoeSBJDQphbHNvIGRlY2lkZWQgdG8gcHV0IGFwYXJ0IHRoZSBzdW0gb2YgICQyNy41bWls
bGlvbiBEb2xsYXJzIHdoaWNoIGlzDQpzdGlsbCBpbiBvdXIgYmFuayB1bmRlciBteSBjdXN0b2R5
IGZvciBhIGxvbmcgcGVyaW9kIG5vdyEgSSBoYXZlIHRvDQpnaXZlIHlvdSBhbGwgdGhlIHJlcXVp
cmVkIGd1aWRlbGluZXMgc28gdGhhdCB5b3UgZG8gbm90IG1ha2UgYW55DQptaXN0YWtlLiBJZiB5
b3UgYXJlIGNhcGFibGUgdG8gaGFuZGxlIHRoZSB0cmFuc2FjdGlvbiBDb250YWN0IG1lIGZvcg0K
bW9yZSBkZXRhaWxzLiBLaW5kbHkgcmVwbHkgbWUgYmFjayB0byBteSBhbHRlcm5hdGl2ZSBlbWFp
bCBhZGRyZXNzDQoobXIubHVpc2Zlcm5hbmRvNTA1MEBnbWFpbC5jb20pIE1yLmx1aXMgRmVybmFu
ZG8NCg==
