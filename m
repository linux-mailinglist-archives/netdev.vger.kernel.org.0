Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C8A2831C2
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgJEITv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:19:51 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:35263 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgJEITu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 04:19:50 -0400
Received: by mail-lf1-f67.google.com with SMTP id w11so9803249lfn.2;
        Mon, 05 Oct 2020 01:19:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q4XZrXEeQD517Aqzlbe9SxhNn9MS2ME8Yf3Gk4LM/sc=;
        b=Z0eTS6wkdakt7z8JAuccJ3Bo/6i9KkIAnCR/lVi130QkTevqXszRWzOGBDRIWQeux/
         PcImaqDeDYKn7EqqgON0tHwD0SM4XASHx8RIIl67ucQxDCmVTJFGEnut0QdXF85NzoAO
         Bdq4vwKGXUSjsdLDThF3aQi85uduV8gzzTKP2alGzONOdRLVYw832Zm98R2bTQem/8g5
         Ae3l9rKQ866HZMqD3+82ehM4XRhXqEm2S9WlXVvVXUM4MbF9FgR0RY2804OXjo0qAMrv
         oCI0Hkm5fgqfsKmk3E7jYeVhhe4MiuUeU58t92TETlw4ZIadmWNL/dV4zwFHYNAjKFZH
         ecFw==
X-Gm-Message-State: AOAM530bMyH95brR8KFs3gDQmQnV5wucIfLMLqLD4SFZJEmkPycfyyjz
        aIeTiI+UQ3CCjPbwhARM1Gs=
X-Google-Smtp-Source: ABdhPJzBO+i0G1WlEF/XcGMfyolfNZxzJtOqB8x0vXbXApEAKorWqT2Xqz9AF+kZWMnBtTWOyZs8SQ==
X-Received: by 2002:a05:6512:31d:: with SMTP id t29mr2351786lfp.327.1601885989265;
        Mon, 05 Oct 2020 01:19:49 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id a28sm264798lfi.60.2020.10.05.01.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 01:19:48 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kPLii-0001TC-FA; Mon, 05 Oct 2020 10:19:45 +0200
Date:   Mon, 5 Oct 2020 10:19:44 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: serial: qmi_wwan: add Cellient MPL200 card
Message-ID: <20201005081944.GK5141@localhost>
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
 <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
 <87d01yovq5.fsf@miraculix.mork.no>
 <20201004203042.093ac473@monster.powergraphx.local>
 <20201005080612.GI5141@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005080612.GI5141@localhost>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 10:06:12AM +0200, Johan Hovold wrote:
> On Sun, Oct 04, 2020 at 08:30:42PM +0200, Wilken Gottwalt wrote:

> > Oh sorry, looks like I got it mixed up a bit. It was my first attempt to submit
> > a patch set. Which is the best way to resubmit an update if the other part of
> > the patch set gets accepted? The documentation about re-/submitting patch sets
> > is a bit thin.
> 
> Just send these as individual patches (not a series) as they are
> independent and go through separate trees.
> 
> Also, I never received the USB serial patch, only this one, so you need
> to resend both anyway.

Found it flagged spam, so no need to resend that one.

Just resend the networking one with a v2 prefix. In general, you could
mention in a changelog in the cover letter that you've removed patches
that have already been applied.

Johan
