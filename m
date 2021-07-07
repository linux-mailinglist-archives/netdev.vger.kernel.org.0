Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68B73BE8BA
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhGGN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhGGN2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:28:41 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D51EC061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 06:26:01 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id a11so2688188ilf.2
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 06:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Yt62TszKcb4A7QGJ+yn+kt/XDSMoUeLI/qXsSaEOtik=;
        b=Dkm7u5P9bGgiQnUivN7u5PixoHiH2JfwEVEKx9dQpa4+Ix4J7x8BSuvyC35QOVzFNd
         KBjxsoX8VtPF/nhDcxW8hl9jKwvrQrYSfSwEsAEgwOeuBvGY76Nr0kFBUhTfKOU6RJ8j
         bFRPT9+QFzkgukL+hs7owLldbGPHxT04NybvTRemg9ZAnkID2U3oFDI6pQVZDz7aTuP4
         EsanB5nZ/x57qpt7Vzbfj2llMDaUe4SpiLlmVT1nKfuxVGzcqhDDCid7CeewWUAMrU5I
         eFO7t5cXyqD9imwZ0kSFXIs8+DyGfGIDj6t65iV7Syo+CeoUgRhz/gEodCoxk/LRmVDO
         yM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=Yt62TszKcb4A7QGJ+yn+kt/XDSMoUeLI/qXsSaEOtik=;
        b=lXgBy2IVUthDts+nuhU7OyOVhU3Ewd/57Kg22o/SlUZ9gE2KaIxbDD5FiS42XzH+uh
         BSa4IlTwCJm7J7iEGNMFeV60pawjireRwtGDYC17xeYt0YZUTGaZ2GJhT+AZvNgRl2O+
         fLOxb1FcbueI7W6I8vRMIRsZNs4A420AW8V6naVbaK6ourmK5rtHt+WuOm9KI+jLxPE+
         YGZ4njyLgbzEhFMeH9ru7VQBhMSEsAD3rsUWpXVX3+Ts/sMyNyEFlqlYCk0fmEKEgsZ4
         8LXIR4yfH5GspSesrkj65zRjFrWN6gSX9+RWTpWGRvucl/06vv3kVFKtWHB2RNykT9AQ
         4KxQ==
X-Gm-Message-State: AOAM532ucdqzNYfTMUk28Dt+6uuKPjjIJAkR/SygyRbWBhNjEwhamOlK
        RST6TQCCE6tkzHNnp2rE4yAqrSfHMNaR5B+YvFg=
X-Google-Smtp-Source: ABdhPJwFIqxWZv+iSpEB9zU51vTlaCj4uA02K0PwuQMtPrGHSo3q9bNQMdY4xzn5R+mEqDmb8Uti6wVzT1n5LpTjSko=
X-Received: by 2002:a05:6e02:1a82:: with SMTP id k2mr18891489ilv.173.1625664361110;
 Wed, 07 Jul 2021 06:26:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a92:c56b:0:0:0:0:0 with HTTP; Wed, 7 Jul 2021 06:26:00 -0700 (PDT)
Reply-To: 123456officialnicole@gmail.com
From:   Official Miss <charlesjjjjjj@gmail.com>
Date:   Wed, 7 Jul 2021 13:26:00 +0000
Message-ID: <CAC_kAa+De03S=7rwO-aLL9he4qEkhx_vWEY4OUwfb-nqXca=HA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SXTigJlzIG15IHBsZWFzdXJlIHRvIG1lZXQgeW91DQpJIGhhdmUgc2VudCB5b3UgYW4gZW1haWws
IGRpZCB5b3UgcmVjZWl2ZSBpdD8gSSBoYXZlIHN1cnZpdmVkIHR3byBib21iDQphdHRhY2tzIHdo
aWNoIHByb21wdGVkIG1lIHRvIHNlYXJjaCBvdXQgZm9yIGEgcmVsaWFibGUgYW5kIHRydXN0DQp3
b3J0aHkgcGVyc29uIHRvIGhlbHAgbWUgSSB3b3VsZCBsaWtlIHRvIHZpc2l0IHlvdXIgaG9tZSBj
b3VudHJ5DQpSZWdhcmRzDQpNaXNzIE5pY29sZQ0K44GC44Gq44Gf44Gv44GC44Gq44Gf44Gu6KiA
6Kqe44Gn5pu444GP44GT44Go44GM44Gn44GN44G+44GZDQo=
