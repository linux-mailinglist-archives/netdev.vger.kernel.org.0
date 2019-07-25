Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDF275777
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfGYTAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:00:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43053 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfGYTAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:00:10 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
        (envelope-from <linville@tuxdriver.com>)
        id 1hqiyH-0001Mm-1f
        for netdev@vger.kernel.org; Thu, 25 Jul 2019 15:00:09 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by localhost.localdomain (8.15.2/8.14.6) with ESMTP id x6PIxHeK028548
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 14:59:17 -0400
Received: (from linville@localhost)
        by localhost.localdomain (8.15.2/8.15.2/Submit) id x6PIxHlV028547
        for netdev@vger.kernel.org; Thu, 25 Jul 2019 14:59:17 -0400
Date:   Thu, 25 Jul 2019 14:59:17 -0400
From:   "John W. Linville" <linville@tuxdriver.com>
To:     netdev@vger.kernel.org
Subject: ethtool 5.2 released
Message-ID: <20190725185917.GA23037@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool version 5.2 has been released.

Home page: https://www.kernel.org/pub/software/network/ethtool/
Download link:
https://www.kernel.org/pub/software/network/ethtool/ethtool-5.2.tar.xz

Release notes:

	* Feature: Add 100BaseT1 and 1000BaseT1 link modes
	* Feature: Use standard file location macros in ethtool.spec

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
