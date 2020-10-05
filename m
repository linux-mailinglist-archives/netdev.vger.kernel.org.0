Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5F7E2833D1
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 12:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgJEKHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 06:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgJEKHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 06:07:36 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35176C0613CE;
        Mon,  5 Oct 2020 03:07:36 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 095A7Eld017632
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 5 Oct 2020 12:07:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1601892435; bh=PqmCIbdmGhzQjUN7EiP+m0+p7uGY3mf6YJwZ9pKQlyY=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=M8CCDT0uuaWsIR4WtnFhfSmKkCp0+1fGkT7oNM0BUlkg+BNSA8Xbdoquqo2DGm6wq
         +zA4nLazFyPe8I6Cslr90X/Srm7AjF/hmfBMNyHn4jkF7PllyPi13zMnzulD69SHV3
         hN+A1E7AfVGpBSmicYtxITfv4ltzyQNtdRjKXIJM=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kPNOi-000oZA-E0; Mon, 05 Oct 2020 12:07:12 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: serial: qmi_wwan: add Cellient MPL200 card
Organization: m
References: <cover.1601715478.git.wilken.gottwalt@mailbox.org>
        <4688927cbf36fe0027340ea5e0c3aaf1445ba256.1601715478.git.wilken.gottwalt@mailbox.org>
        <87d01yovq5.fsf@miraculix.mork.no>
        <20201004203042.093ac473@monster.powergraphx.local>
Date:   Mon, 05 Oct 2020 12:07:12 +0200
In-Reply-To: <20201004203042.093ac473@monster.powergraphx.local> (Wilken
        Gottwalt's message of "Sun, 4 Oct 2020 20:30:42 +0200")
Message-ID: <87eemdnfzj.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wilken Gottwalt <wilken.gottwalt@mailbox.org> writes:

> Oh sorry, looks like I got it mixed up a bit. It was my first attempt to =
submit
> a patch set. Which is the best way to resubmit an update if the other par=
t of
> the patch set gets accepted? The documentation about re-/submitting patch=
 sets
> is a bit thin.

I see that Johan already has answered this.  Just wanted to add that you
don't need to worry about doing anything wrong.  It was not my intention
to scare you :-) Fixing up and resending patches is a natural part of
the patch submission process.  Don't be afraid to resubmit.  The worst
that can happen is that you'll be asked to fix up something else.
That's not a problem.

The most important part is to make it clear that a resubmission replaces
an earlier version of the same patch.  This should be visible in the
subject.  E.g by using a revision number inside the brackes, like

  [PATCH v2] net: qmi_wwan: add Cellient MPL200 card

This tells us that the patch is a revised "v2" of an earlier patch, and
that it replaces "v1".  Patches without an explicit revision will then
be assumed to be "v1".

If you are sending a series, then the whole series should usually be
resubmitted with the new revsion number.  Even patches without any
changes. The cover letter should then also summarize the changes for
each revisions.  But as Johan said: The USB serial and net patches go
through different trees and are therefore best handled as standalone
patches, even if they deal with the same USB composite device.=20


Bj=C3=B8rn
