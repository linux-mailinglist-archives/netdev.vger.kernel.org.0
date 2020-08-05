Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C18223CC49
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgHEQfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:35:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:57650 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbgHEQeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 12:34:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B1C21AF72;
        Wed,  5 Aug 2020 12:28:41 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Subject: [PATCH 0/3] misc bug fixes for the hso driver 
Date:   Wed,  5 Aug 2020 14:07:06 +0200
Message-Id: <20200805120709.4676-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Code reuse led to an unregistration of a net driver that has not been
registered
2. The kernel complains generically if kmalloc with GFP_KERNEL fails
3. A race that can lead to an URB that is in use being reused or
a use after free

