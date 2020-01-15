Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46B713CAE3
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 18:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAORYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 12:24:24 -0500
Received: from mail-io1-f52.google.com ([209.85.166.52]:38134 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAORYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 12:24:23 -0500
Received: by mail-io1-f52.google.com with SMTP id i7so10216019ioo.5
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 09:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=LJYDOYPoMTTFEzN8iN5iPSdIcUq2HE9sqFVa/D/VIlQ=;
        b=dUEBl2C0LPGCQEZfPExVgXfOXl3FvC5v0rCu6WUULGCUmLGIg5zzI7OvCwfEz+uEE4
         OloHEPxDwC9taYARTKWkCR3VJCLdxXvs0X//g2PaPTY6PeFh6fTxP7GypClQmOUOorah
         34uJtE2/VhiMsIxQdospxRsx3ldo0f/47szZrV662bBp1/1AiypwGXqoEIJqU1NGwbTR
         DPmvdAH0k6yz6/6SUmwni+OxAicbbcuWpnqGh9yQM6gAbKmpPCk6P/8338No+x2/qUrc
         Qa+KD//iguNsVd9cDjfhcsrBD0wbsqILFXBtsNbMQ/Gwq+Xr5vNmktinltLzWGlJxCmM
         RClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=LJYDOYPoMTTFEzN8iN5iPSdIcUq2HE9sqFVa/D/VIlQ=;
        b=AyVbK4lDyCwjnunJLMiG+SSZYlvZscHF3up3skdt9Jw/X2Ku0pqlG/ve/AgreaQCA8
         ta5seCPj8uy307uRmbUzDqHC/6FrtsHCUUHA7zliwbbS0kH9R4co33XvhRWVy9+7jgc0
         lI4eTqP8DN60o69ZHYMH8iWuZVh+KGujAjyl0xocXlDZRcxdW0nTKHuUFE4TNEvArJok
         jBlDCXKGCu9zv5Rf0OTtCHwabvAJvXKJCTXCC9g5hIdV0gm/SJKhkhnzbXxS++U76MEk
         OfL/p30Ur5iEG5zvkfRR3W4KapeC3gh5eA+Ejp3kQTbCjjOsmnCoj+0Bu7e3Dj9n0xnr
         iKgw==
X-Gm-Message-State: APjAAAXEwVA4ZhKY29FFubOjcdrN8K1nK4+y5MLqMnweI4KXvG9L7tMa
        waAtsrZVU8Hb+LS+RqOUuQe9+my3sq2TONCYgdQ=
X-Google-Smtp-Source: APXvYqyc42lon9EnWoi/YtA8YcQn4dAWeTeA5dfPpkc597wO2i2VdDJSm3gslwXJ6Q5c2i6/dfeKQ1IG3fzap+XPnJE=
X-Received: by 2002:a05:6638:a99:: with SMTP id 25mr25493655jas.37.1579109063038;
 Wed, 15 Jan 2020 09:24:23 -0800 (PST)
MIME-Version: 1.0
References: <CADYdroOZ37YY5-+oRB9xb0KdeWGVz3C2skAccYX4htEYp7mvhA@mail.gmail.com>
In-Reply-To: <CADYdroOZ37YY5-+oRB9xb0KdeWGVz3C2skAccYX4htEYp7mvhA@mail.gmail.com>
From:   Norbert Lange <nolange79@gmail.com>
Date:   Wed, 15 Jan 2020 18:24:12 +0100
Message-ID: <CADYdroOqvmm-CXyk6rORPPx3igTKNVrGQJWunvFQqs06v1kfMQ@mail.gmail.com>
Subject: Re: PROBLEM: kernel crash when unbinding igb device with 4.19.94
To:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Small correction:
I ran various versions from 4.14 up to 4.19.89, and *4.19.94* with above
patch reversed, all which did not have this issue.
