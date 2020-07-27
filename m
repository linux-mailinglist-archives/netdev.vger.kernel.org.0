Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D724E22ED48
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbgG0N20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbgG0N20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:28:26 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13BCC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:28:25 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j22so3100336lfm.2
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gOqZtq8jjYGsRrVE9SfOle2aGRnGjTTajFWgsMLd7gI=;
        b=oS9RvDUMQeGfwmgdSCWGfV1B2GIKKEJhFrjFeWhGkG7qgakjvxs6REU2MKlHBProdS
         GpwXKK2siUcskNGjWF9vvF446AH5dhXkieeBzX7OWsCEldIbv/E/wf6CZhZvATIO4kf8
         v+OB+xQh1Lyp0Z3yfqCDfY+GEjDXZNi/9YE5syOKWfW0zGSg8alkKPTN+kMFo+Tk7ulV
         wGCknvO0pU/wZ8+bKNO3QsxnyOMmCWONpMApvL9VF38FQVF2oVRgVju/UjVVdBcbTClO
         l6r5jtmsOOv3dCqM2ztlbdzO/gTE2U3Ij37aZoR2DojjI7YkOttQwep4ycWE0dsKTUVK
         Cn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gOqZtq8jjYGsRrVE9SfOle2aGRnGjTTajFWgsMLd7gI=;
        b=haEg9gYvc+uShwjj6NPjnhM25Hoi564n7L314PFA8p+oA3FCxFRgmNnn+S51l/VLdn
         i+C4rTKlXAZ1ojgJuHWdtSQTuBV6G2IXpaX+wxG6w9BYrCQJk34Zd4l0WUbOBXaUVBJ9
         qRkXjpneMZ+iEDOQ6HtFuer/uYc3EtST5QfvhfwTB4UYC5LoCDJRAvxjQqSzv3SiefW/
         qtCTwa+PddKEyOygmehzyhL6ecEwMw+kWLOHDVahTZWkOA8UBlmEbTxWB2JH8IufD3VX
         Q4FxznIjE54SNZkP65sHU1UQywb0sofYZ5Pd/Nt7W+DliHL2NPjqOiH+9sITDxpiDA59
         cBGw==
X-Gm-Message-State: AOAM532mIr1J1h39sfFdMm9CkqWoMfkw6DOeWiUyHsIlmWUxS9dmReIB
        AiT9aJ2ZzUBpaGuzdFenOJ4UCI6tS2K8zS0YObooUQ==
X-Google-Smtp-Source: ABdhPJxGHOXZCG9AsImtYwpDzkDpPQ4nkXAG0kareKMahSYOQsdz7xhKFMJbEbPGn/7D27VIvWTBsU2LlctndTriyKY=
X-Received: by 2002:a19:1c6:: with SMTP id 189mr11675726lfb.158.1595856503472;
 Mon, 27 Jul 2020 06:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134433.1c4ea34e@canb.auug.org.au> <20200727052224.GA933@lst.de>
In-Reply-To: <20200727052224.GA933@lst.de>
From:   Alain Michaud <alainmichaud@google.com>
Date:   Mon, 27 Jul 2020 09:28:12 -0400
Message-ID: <CALWDO_W5mY9_KJwWikCtAZufTqSFnn238C7cPy34RQoqASpxhQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the bluetooth tree
To:     Christoph Hellwig <hch@lst.de>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same here, thanks for the fix!


On Mon, Jul 27, 2020 at 1:22 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The fixup looks good to me, thanks.
