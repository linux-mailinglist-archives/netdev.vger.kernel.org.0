Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58C29BC34
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801766AbgJ0Pne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:43:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800307AbgJ0Pfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 11:35:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67FA322282;
        Tue, 27 Oct 2020 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812939;
        bh=sN5nfxKMbyit8FV6KQa9vm24os+LECcyIzEnWZh+Uwk=;
        h=Date:From:To:Cc:Subject:From;
        b=L4adhgsUAId1oOtpupnG2KVkwEu+sLSLv/4AKsSus+Z1c/Ffmw+oqbHtAlIYnOdZf
         474WEW2z3l3gqUicSpDHFgQ52JaXNQnpm0Xvka27ZTiqVlogel6Sl+GfSwaVI7wX0v
         Twh05Sl0Hl4cAxZyJ61o9wf9hdipGH3MjnzIfU/k=
Date:   Tue, 27 Oct 2020 08:35:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: net-next is OPEN
Message-ID: <20201027083538.60660d52@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

Time to open net-next for new features etc. etc.

Big thanks to everyone spending extra time on code reviews.
