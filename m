Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1F3149E0E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA0Ax7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:53:59 -0500
Received: from locusts.copyleft.no ([193.58.250.85]:51495 "EHLO
        mail.mailgateway.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgA0Ax7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 19:53:59 -0500
X-Greylist: delayed 1297 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jan 2020 19:53:58 EST
Received: from localhost ([127.0.0.1] helo=webmail.mailgateway.no)
        by mail.mailgateway.no with esmtp (Exim 4.72 (FreeBSD))
        (envelope-from <morphex@gmail.com>)
        id 1ivsKC-00036z-5s
        for netdev@vger.kernel.org; Mon, 27 Jan 2020 01:32:20 +0100
Received: from 88.88.135.29
        (SquirrelMail authenticated user morten@nidelven-it.no)
        by webmail.mailgateway.no with HTTP;
        Mon, 27 Jan 2020 01:32:20 +0100
Message-ID: <62b65a1c113097fae38e4616f36aea5f.squirrel@webmail.mailgateway.no>
Date:   Mon, 27 Jan 2020 01:32:20 +0100
Subject: Managing a WiFi interface with a broken driver
From:   "Morten W. Petersen" <morphex@gmail.com>
To:     netdev@vger.kernel.org
Reply-To: morphex@gmail.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

I'm hacking away at an Orange Pi Lite 2.

After problems with the network connection, I created a temporary fix -
which doesn't work for large downloads:

http://blogologue.com/blog_entry?id=1579788589X84

Today I created an updated script, which brings down the entire interface
if something is wrong and brings it back up.

https://blogologue.com/wpas2.sh

However, some time-consuming downloads stop, and it isn't possible to
restart at the point at which they stopped.

I was thinking of using a bridge as a keep-alive and a buffer for when the
interface is torn down and brought back up, but couldn't google a solution
for this.

Is it possible to setup a bridge this way, or should I use something else?

TIA,

Morten

Blogging at https://blogologue.com
On Instagram at https://instagram.com/morphexx
On Twitter at https://twitter.com/blogologue


