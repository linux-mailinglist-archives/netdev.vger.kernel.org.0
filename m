Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D683CFF2B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729352AbfJHQog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:44:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:36546 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727514AbfJHQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:44:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id x80so12495422lff.3;
        Tue, 08 Oct 2019 09:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/oomKU3Ue2is6xiOwCMSrWMkAzmIBP6NBZwxcWGzrnw=;
        b=Ncx0ohAi5O+mdOjWhelQZgbVSEIfc2mVvbq3bAcrUAbMlBAYvg9JVguFomb501sogo
         AvPacSVigW5eSH7gyXED4aaEBXn9XT0jzYZl5ahUcadEQ74IP1nbTZ8UJjJ3SZzDSJaA
         6Z1SccdhmzJdmr5IwoBp2hQrPAWFpVJY+ClWecBJEtdcVZuNiMA0FaeWGY0IozkKjIzw
         H57sgV+vyn+WyTYD53Kh2TjkXFSSJx1nq1cFxAJly3NzWcNpI9ZaWtwLZD8q+w6Fl4xX
         p+z9NY22O0Uue/P8bLvW3GqnamfGx5S7cKVO7Ufays+BIumjpz/Fg5s5B4Fi5fuhA9im
         Hfew==
X-Gm-Message-State: APjAAAVdiUnwXejkkUTaGSPWfEv9wM2ewsgoLH0gLjsQ00JDTe2gtm/e
        OFxoe4mQkd8CXLyae07lJJU8t1Db
X-Google-Smtp-Source: APXvYqzcteOm3uTrWh+OKbO0eERZu0OYBR+7ScJFWAjegqTtRhEImpniRIfrG2cgzJFRP/fbGIk7Mg==
X-Received: by 2002:a19:c6d5:: with SMTP id w204mr7172045lff.53.1570553073910;
        Tue, 08 Oct 2019 09:44:33 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id o13sm4022281ljh.35.2019.10.08.09.44.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:44:32 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@kernel.org>)
        id 1iHsbH-0007GE-Vz; Tue, 08 Oct 2019 18:44:40 +0200
Date:   Tue, 8 Oct 2019 18:44:39 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johan Hovold <johan@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Denis Efremov <efremov@linux.com>
Subject: Re: [PATCH 1/2] Revert "rsi: fix potential null dereference in
 rsi_probe()"
Message-ID: <20191008164439.GA27819@localhost>
References: <20191004144422.13003-1-johan@kernel.org>
 <87a7aes2oh.fsf@codeaurora.org>
 <87pnj7grii.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pnj7grii.fsf@tynnyri.adurom.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 06:56:37PM +0300, Kalle Valo wrote:
> Kalle Valo <kvalo@codeaurora.org> writes:
> 
> > Johan Hovold <johan@kernel.org> writes:
> >
> >> This reverts commit f170d44bc4ec2feae5f6206980e7ae7fbf0432a0.
> >>
> >> USB core will never call a USB-driver probe function with a NULL
> >> device-id pointer.
> >>
> >> Reverting before removing the existing checks in order to document this
> >> and prevent the offending commit from being "autoselected" for stable.
> >>
> >> Signed-off-by: Johan Hovold <johan@kernel.org>
> >
> > I'll queue these two to v5.4.
> 
> Actually I'll take that back. Commit f170d44bc4ec is in -next so I have
> to also queue these to -next.

That's right. I'm assuming you don't rebase your branches, otherwise
just dropping the offending patch might of course be an option instead
of the revert.

Johan
