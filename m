Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34725A741
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfF1W7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:59:06 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33667 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfF1W7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 18:59:05 -0400
Received: by mail-lj1-f194.google.com with SMTP id h10so7509984ljg.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5hxr737kZawIDdGnBRfezwRYZfPo+N/0q3w7Fxi9l4A=;
        b=VF6Qdhuv7A1bSXPlb3IW1+FrjzPu/5kLqJR8Bz3t4QYSsRmFGPpUKtjDK+76denozn
         16FGNec6EkruICXjbpFZ9+3J36uau6xjWzLCfmQ1pkX2GY6gfKFgHUUoAsIpsrM4gUfb
         2J1/qNcGNldERB23rgLKXTx1gg+Ws1OyBf04k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5hxr737kZawIDdGnBRfezwRYZfPo+N/0q3w7Fxi9l4A=;
        b=LJIO0J4mCMf1KDk1jUedxHQkzhBkeToj6qJJsHv3DaP9bJSYCTCoS/HKDbVksIKAj2
         aokjoCKVMAoBii7BBsTUQGKuAFB+nt/lHSjCrzqE4EnSRJDCDJC4LcQGi+3F/V7w6ZCC
         cZXUSTG6/icCD1pdsI/M1WdhcxUjQLnm5FqQUZ0ixBowgIcE9RCnTkdW/oMFhm/VC/T0
         sszVz9hLyzhq6Iom29bqiGIdgcaolJyQEuAnT0N3pXrxjrVxXku9mK32yJnUYXOeP4dK
         jyz4SBTMSOgEEMKb3z1wziJGUPOye0/74BDC67dL8qqDxTTzW2qfxaOIEiXvmttJ/pF9
         60Nw==
X-Gm-Message-State: APjAAAV9dKTEmGBrZjKXs4Nb9f+Z9DDDV61dGsPn9ZieN9JwgU0HcHVs
        fW9JP/Ufr3R42thsQuOyJNAx4aBacFc=
X-Google-Smtp-Source: APXvYqyzr/s+w0D+TGSCR2zSaqewbcVEmZ5Wysw7Xr+N4vIRILRfDjZR4CX4QrcSwxuvE6tfkPHnLA==
X-Received: by 2002:a2e:298a:: with SMTP id p10mr7422640ljp.74.1561762742224;
        Fri, 28 Jun 2019 15:59:02 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id u11sm1247877ljd.90.2019.06.28.15.59.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 15:59:02 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id v18so7483912ljh.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 15:59:01 -0700 (PDT)
X-Received: by 2002:a2e:9758:: with SMTP id f24mr7644626ljj.58.1561762740673;
 Fri, 28 Jun 2019 15:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190627003616.20767-1-sashal@kernel.org> <20190627003616.20767-14-sashal@kernel.org>
In-Reply-To: <20190627003616.20767-14-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 28 Jun 2019 15:58:49 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPyGECiq9gZmFj8TU6Gmt2epQtuBqnGqRWad79DJT589w@mail.gmail.com>
Message-ID: <CA+ASDXPyGECiq9gZmFj8TU6Gmt2epQtuBqnGqRWad79DJT589w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 14/60] mwifiex: Abort at too short BSS
 descriptor element
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 5:49 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Takashi Iwai <tiwai@suse.de>
>
> [ Upstream commit 685c9b7750bfacd6fc1db50d86579980593b7869 ]
>
> Currently mwifiex_update_bss_desc_with_ie() implicitly assumes that
> the source descriptor entries contain the enough size for each type
> and performs copying without checking the source size.  This may lead
> to read over boundary.
>
> Fix this by putting the source size check in appropriate places.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

For the record, this fixup is still aiming for 5.2, correcting some
potential mistakes in this patch:

63d7ef36103d mwifiex: Don't abort on small, spec-compliant vendor IEs

So you might want to hold off a bit, and grab them both.

Brian
