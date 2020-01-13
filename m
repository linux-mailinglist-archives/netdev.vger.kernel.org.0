Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA930139002
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgAMLXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:23:36 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39197 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgAMLXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 06:23:36 -0500
Received: by mail-io1-f68.google.com with SMTP id c16so9369463ioh.6
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 03:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U4v91slysBtu2+ZNUNp733HGyuTdWdB0vCTPvzlAMaQ=;
        b=Hs40/hCtDaw8kIdqbXXKtTxZGwlkdcXPIDSr52sBt9lKZdJOA8HTIs1ZJ6HDFBBSPi
         VQ29OLELQpXHhFZ7d3W2i8YPFQNotSpRMRfktWCTtklFthmuOj+HiqKwvTFybvX7EeIU
         17M7lpOhht4JNwwXL8Syph5dMdt6WeUH641P95PEbNJy/TD1t2gXTe4Xm25TRe8Ai5T+
         y2kJPxuaHzZcBDfLYg8Gxrel4rToqKqV/alyquGkWsJr7CX0alX/MGe/xyLb08aRIsGr
         2cSxy/i7JUBgY8X5p9Qq+yLCv44Pg+emYzgR/Ou2ozfELUGO36BSInuQuZfWtRTceGnm
         alHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U4v91slysBtu2+ZNUNp733HGyuTdWdB0vCTPvzlAMaQ=;
        b=qtxw5irO0gSMgQyfJk8gWLTdawDu7n9F5BqT0WNShQBMxe3dcnjuiud5+SOlShfqm+
         K5BiKD1ulQZ7SCMjwoQeZPcRASmOEwVAbS0W5o5oJqQIk8KdWKbFlUgcPe79dAWJDWzY
         BQQgxyth1qiZcZKYxcpzcvK2/aq0mYLpB2TkyhP5YBCgTt6PEY34o8nk49egaW02m0fb
         FicfUV9ZrVodAeuaXx2OxXH6lLaYEhjIx6Y+rcM9bhZAN4cYXb+VxivGV8TaI65Bor1z
         lA4E9T5wzifsymU5RbmP48wdb9eoo9m54lFQKiV4wXOhYTzA/XY6KwLTXpJEV8pUNXWS
         u9AA==
X-Gm-Message-State: APjAAAXtFinLUo1ydOFCIIymXtYC1u0k6wOVLrSYT19PgskkxUMAChnz
        Cs0mSnq0E4cTOay5DMijLkqrGFm1fMqRu29dnpETtQ==
X-Google-Smtp-Source: APXvYqz3R0cwnpdFNzGF+9v6caVTmnupsODQb8Q35NPNszuiOcxuERTT/1cGd+mLaOMrq7IQY9L3CBVEeb5VduDXGpE=
X-Received: by 2002:a5e:c606:: with SMTP id f6mr12207438iok.71.1578914615813;
 Mon, 13 Jan 2020 03:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
 <20200112125055.512b65f6@cakuba> <CAMGffEntn9nQAUk5ejEiEfnSjGda20rqQVi-zNu+GFr3v39pAA@mail.gmail.com>
 <20200113032030.2fc9d891@cakuba>
In-Reply-To: <20200113032030.2fc9d891@cakuba>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 13 Jan 2020 12:23:24 +0100
Message-ID: <CAMGffEm1ruZsen6RwH3sSaV8LCHxBBRkBttJ2J1nDyq4N+2VwA@mail.gmail.com>
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev <netdev@vger.kernel.org>, tariqt@mellanox.com,
        "David S. Miller" <davem@davemloft.net>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 12:20 PM Jakub Kicinski <kubakici@wp.pl> wrote:
>
> On Mon, 13 Jan 2020 09:47:59 +0100, Jinpu Wang wrote:
> > On Sun, Jan 12, 2020 at 9:51 PM Jakub Kicinski <kubakici@wp.pl> wrote:
> > > On Thu, 9 Jan 2020 11:23:17 -0800, Jonathan Lemon wrote:
> > > > On modern hardware with a large number of cpus and using XDP,
> > > > the current MSIX limit is insufficient.  Bump the limit in
> > > > order to allow more queues.
> > > >
> > > > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > >
> > > Applied to net-next, thanks everyone!
> > >
> > > (Jack, please make sure you spell your tags right)
> > Checked, It's correct both in my reply and in net-next.git.
>
> I manually corrected it in tree. You swapped 'i' and 'e'
> in the word reviewed, your email had "reveiwed".
oh, sorry for that, will be more careful next time.
And thanks for the correction.
