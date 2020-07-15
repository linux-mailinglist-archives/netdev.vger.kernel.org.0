Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACAD220655
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 09:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgGOHhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 03:37:18 -0400
Received: from verein.lst.de ([213.95.11.211]:57981 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgGOHhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 03:37:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 949496736F; Wed, 15 Jul 2020 09:37:15 +0200 (CEST)
Date:   Wed, 15 Jul 2020 09:37:15 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Doug Nazar <nazard@nazar.ca>, Christoph Hellwig <hch@lst.de>,
        ericvh@gmail.com, lucho@ionkov.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e6f77e16ff68b2434a2c@syzkaller.appspotmail.com
Subject: Re: [PATCH] net/9p: validate fds in p9_fd_open
Message-ID: <20200715073715.GA22899@lst.de>
References: <20200710085722.435850-1-hch@lst.de> <5bee3e33-2400-2d85-080e-d10cd82b0d85@nazar.ca> <20200711104923.GA6584@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711104923.GA6584@nautica>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FYI, this is now generating daily syzbot reports, so I'd love to see
the fix going into Linus' tree ASAP..
