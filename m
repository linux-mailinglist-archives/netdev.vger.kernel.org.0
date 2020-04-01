Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BCCD19B4BC
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 19:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732661AbgDARfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 13:35:19 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:35213 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732196AbgDARfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 13:35:19 -0400
Received: by mail-pg1-f202.google.com with SMTP id k67so540707pga.2
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 10:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=llCpE/mG94XbxehHcS3fpQs9KrEDWRDGRcAjU8ExJ4U=;
        b=pyJh3p8RNFxDvJu+8EyOfw0HwzsQdsKrm1/g59jSqy3qBfZYhOVFUSj2vHGn0RxbBr
         CZ921nfgLnwQcGXqh2nSa8URFicaU26aZjpXA59A79Erkmi3SxtxSFNayBBJ3axdaVF8
         +FBufOynExC0/8Dx9l+nIO4C43a7imucMwVElT50ASuSOzVpF9i2fEeHE29vzdnP3iIC
         6dhjx/a2Kw6UsLtEa7Dh1pmxz1gcQqVJMcAA2qfUxRfaGII3HpaYHx77bp91xj7Vb/G9
         efL7biRNwPDgPqWp+W65Clg9EkyL/ojnsZ8r2SJFULs8QbExqfdyvZFCByfo+JUUu7y7
         HJow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=llCpE/mG94XbxehHcS3fpQs9KrEDWRDGRcAjU8ExJ4U=;
        b=Q0I/GxHkQ0bRCvLQfnBaWLJsxBcxJSvRdr4PNiJjEVvLn0FBfe8mEUA0tEz4ynn9er
         gdfe/fAtuNHl8ZNrAahB1EsmjJy9V/OZowvV1k8NdCqibMWFS+WNx8BL1j9eeTeo7fVd
         O795VdHkgtrN8a8To/MyD+V2PxhTRoDpoBZO9SxjJAOYfUlfzKu9JoPF2T1dufO93hAA
         PnsVvf1LgKqZxG1xZs2j8q3qm9iZKUNrRP6/MiWg9CaoSU8Nn/YFU/wA1VlSiA8Fm7/0
         xU769yPCLjX4rjaki41gWQnS2s0lZrHJgptraiG+8qN3LYgc5ZWQdy4c5a31ooJ5BBKG
         QkQQ==
X-Gm-Message-State: AGi0PubfkPQ9TFSR6zhkuNqZB9bCQ9a2/ouzpimGl2iH2YU8xSo8EefW
        0JHXpq09izYU0KcUBj/hEtK41IqF8wJJTrpHgYw=
X-Google-Smtp-Source: APiQypJYzX3YC2rPgsuTQR6O2ggyRBoFiWW2pJcsW7nszWoPGrKojOUw/ges8p69MPhlPToU8Ed3Avvg9q/o/xvkHBE=
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr6413183pjs.12.1585762517679;
 Wed, 01 Apr 2020 10:35:17 -0700 (PDT)
Date:   Wed,  1 Apr 2020 10:35:15 -0700
In-Reply-To: <20200311024240.26834-1-elder@linaro.org>
Message-Id: <20200401173515.142249-1-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200311024240.26834-1-elder@linaro.org>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
Subject: Re: [PATCH v3] bitfield.h: add FIELD_MAX() and field_max()
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     elder@linaro.org
Cc:     arnd@arndb.de, bjorn.andersson@linaro.org, davem@davemloft.net,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, masahiroy@kernel.org,
        natechancellor@gmail.com, netdev@vger.kernel.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Define FIELD_MAX(), which supplies the maximum value that can be
> represented by a field value.  Define field_max() as well, to go
> along with the lower-case forms of the field mask functions.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v3: Rebased on latest netdev-next/master.
> 
> David, please take this into net-next as soon as possible.  When the
> IPA code was merged the other day this prerequisite patch was not
> included, and as a result the IPA driver fails to build.  Thank you.
> 
>   See: https://lkml.org/lkml/2020/3/10/1839
> 
> 					-Alex

In particular, this seems to now have regressed into mainline for the 5.7
merge window as reported by Linaro's ToolChain Working Group's CI.
Link: https://github.com/ClangBuiltLinux/linux/issues/963
