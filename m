Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AA0197691
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 10:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgC3Ihw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 04:37:52 -0400
Received: from mail.thelounge.net ([91.118.73.15]:41091 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgC3Ihw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 04:37:52 -0400
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 48rQnn1f4RzXMK
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 10:37:49 +0200 (CEST)
To:     netdev@vger.kernel.org
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: 5.6: how to enable wireguard in "make menuconfig"
Organization: the lounge interactive design
Message-ID: <439d7aec-3052-bbfc-94b9-2f85085e4976@thelounge.net>
Date:   Mon, 30 Mar 2020 10:37:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

https://i.imgur.com/jcH9Xno.png
https://www.wireguard.com/compilation/

crypto wise i have in the meantime enabled everything and the same in
"networking options"

but "IP: WireGuard secure network tunnel" still don#t appear anywhere :-(
