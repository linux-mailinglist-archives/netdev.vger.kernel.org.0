Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982FC3EBB3F
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhHMRUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229533AbhHMRUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:20:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5835B60F91;
        Fri, 13 Aug 2021 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628875184;
        bh=izU8ZUapFdpvhbhbUdcUZJTQKe3rzpm5wUiyiCqVDtk=;
        h=From:To:Cc:Subject:Date:From;
        b=ploiQruywnVUkjKvQe6Gd+bFVjh84ZVLiFqveodJmcnjU1X314i+u5rMYrdJqcN/5
         vr5tLt8y5UprO8SOC38zNb0WngytF9bYqpoe4a1lAgQgUG/ufkUHleHBqJgfATCIXR
         6xgFaZgEVQcZ7m/qKDqv9Z5GNOzObfBv5pLVj0KJ1s+uu+N0uivZd224MM6skWaaaO
         uOEVSc01uVw2CeIe5mVikww57gfmCO9vg/O4ndqk+PuYbRiEg5ctOlW7VvFLooCy22
         pJZLUiv21FCKE3S2Jei7aJ0ws1r7rOh5AmLTT9q07UNZjPKDPchuke48Rhd7kkDeKZ
         MVGG6pvzuGgXQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, dcavalca@fb.com, filbranden@fb.com,
        michel@fb.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool 0/3] ethool: make --json reliable
Date:   Fri, 13 Aug 2021 10:19:35 -0700
Message-Id: <20210813171938.1127891-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to make --json fail if the output is not
JSON formatted. This should make writing scripts around
ethtool less error prone and give us stronger signal when
produced JSON is invalid.

Jakub Kicinski (3):
  ethtool: remove questionable goto
  ethtool: use dummy args[] entry for no-args case
  ethtool: return error if command does not support --json

 ethtool.c | 52 ++++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

-- 
2.31.1

