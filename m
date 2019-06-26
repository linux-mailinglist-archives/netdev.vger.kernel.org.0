Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D9956CFE
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfFZO7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:59:30 -0400
Received: from gateway20.websitewelcome.com ([192.185.51.6]:18578 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726029AbfFZO7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:59:30 -0400
X-Greylist: delayed 1503 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2019 10:59:30 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 3A78D400C81C9
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:10:44 -0500 (CDT)
Received: from gator3278.hostgator.com ([198.57.247.242])
        by cmsmtp with SMTP
        id g8f0hcf7VdnCeg8f0hCJrq; Wed, 26 Jun 2019 09:12:30 -0500
X-Authority-Reason: nr=8
Received: from 89-69-237-178.dynamic.chello.pl ([89.69.237.178]:58354 helo=localhost)
        by gator3278.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <arkadiusz@drabczyk.org>)
        id 1hg8ez-002APb-5d; Wed, 26 Jun 2019 09:12:29 -0500
Date:   Wed, 26 Jun 2019 16:12:48 +0200
From:   Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
To:     netdev@vger.kernel.org
Cc:     jacmet@sunsite.dk
Subject: dm9601: incorrect datasheet URL
Message-ID: <20190626141248.GA14356@comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.6.1 (2016-04-27)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator3278.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - drabczyk.org
X-BWhitelist: no
X-Source-IP: 89.69.237.178
X-Source-L: No
X-Exim-ID: 1hg8ez-002APb-5d
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 89-69-237-178.dynamic.chello.pl (localhost) [89.69.237.178]:58354
X-Source-Auth: arkadiusz@drabczyk.org
X-Email-Count: 2
X-Source-Cap: cmt1bXZicmg7cmt1bXZicmg7Z2F0b3IzMjc4Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

http://ptm2.cc.utu.fi/ftp/network/cards/DM9601/From_NET/DM9601-DS-P01-930914.pdf
is gone. In fact, document titled `DM9601-DS-P01-930914.pdf' is
nowhere to be found online these days but there is
http://pdf.datasheet.live/74029349/davicom.com.tw/DM9601E.pdf. I'm
just not sure if this is the same document that the current link was
pointing to and what does E suffix mean. There is also
https://www.alldatasheet.com/datasheet-pdf/pdf/119750/ETC1/DM9601.html
but notice that it says `Version: DM9601-DS-F01' on the bottom of some
pages and `Version: DM9601-DS-P01' on others - I don't know what that
means.

Should http://pdf.datasheet.live/74029349/davicom.com.tw/DM9601E.pdf
be used as a datasheet URL?

-- 
Arkadiusz Drabczyk <arkadiusz@drabczyk.org>
