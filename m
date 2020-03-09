Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F0217DC17
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgCIJGd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Mar 2020 05:06:33 -0400
Received: from proxmox-new.maurer-it.com ([212.186.127.180]:42137 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCIJGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 05:06:32 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2020 05:06:31 EDT
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id CA70D40AD7;
        Mon,  9 Mar 2020 09:59:34 +0100 (CET)
Date:   Mon, 09 Mar 2020 09:59:30 +0100
From:   Fabian =?iso-8859-1?q?Gr=FCnbichler?= <f.gruenbichler@proxmox.com>
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Alarig Le Lay <alarig@swordarmor.fr>,
        David Ahern <dsahern@gmail.com>
Cc:     Vincent Bernat <bernat@debian.org>, jack@basilfillan.uk,
        netdev@vger.kernel.org
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
        <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
        <20200308105729.72pbglywnahbl7hs@mew.swordarmor.fr>
        <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
In-Reply-To: <27457094-b62a-f029-e259-f7a274fee49d@gmail.com>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1583744251.2qt66u32rz.astroid@nora.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On March 9, 2020 3:15 am, David Ahern wrote:
> On 3/8/20 4:57 AM, Alarig Le Lay wrote:
>> On sam.  7 mars 17:52:10 2020, David Ahern wrote:
>> I have the problem with 5.3 (proxmox 6), so unless FIB handling has been
>> changed since then, I doubt that it will works, but I will try on
>> Monday.
>> 
> 
> a fair amount of changes went in through 5.4 including improvements to
> neighbor handling. 5.4 (I think) also had changes around dumping the
> route cache.

FWIW, there is a 5.4-based kernel preview package available in the 
pvetest repository for Proxmox VE 6.x:

http://download.proxmox.com/debian/pve/dists/buster/pvetest/binary-amd64/pve-kernel-5.4.22-1-pve_5.4.22-1_amd64.deb

