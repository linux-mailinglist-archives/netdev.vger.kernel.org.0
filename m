Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC87F29DBC8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390756AbgJ2ANJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50726 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390748AbgJ2ANJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZo2-003u63-FD; Wed, 28 Oct 2020 01:59:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: ceph: Fix most of the kerneldoc warings
Date:   Wed, 28 Oct 2020 01:59:07 +0100
Message-Id: <20201028005907.930575-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oid' not described in 'ceph_cls_break_lock'
net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'oloc' not described in 'ceph_cls_break_lock'
net/ceph/cls_lock_client.c:143: warning: Function parameter or member 'osdc' not described in 'ceph_cls_break_lock'
net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'oid' not described in 'ceph_cls_lock'
net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'oloc' not described in 'ceph_cls_lock'
net/ceph/cls_lock_client.c:28: warning: Function parameter or member 'osdc' not described in 'ceph_cls_lock'
net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'oid' not described in 'ceph_cls_unlock'
net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'oloc' not described in 'ceph_cls_unlock'
net/ceph/cls_lock_client.c:93: warning: Function parameter or member 'osdc' not described in 'ceph_cls_unlock'
net/ceph/crush/mapper.c:466: warning: Function parameter or member 'choose_args' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:466: warning: Function parameter or member 'weight_max' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:466: warning: Function parameter or member 'weight' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:466: warning: Function parameter or member 'work' not described in 'crush_choose_firstn'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'bucket' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'choose_args' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'map' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'numrep' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'out2' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'out' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'outpos' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'parent_r' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'recurse_to_leaf' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'recurse_tries' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'tries' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'type' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'weight_max' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'weight' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'work' not described in 'crush_choose_indep'
net/ceph/crush/mapper.c:655: warning: Function parameter or member 'x' not described in 'crush_choose_indep'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ceph/cls_lock_client.c | 12 +++++++++---
 net/ceph/crush/mapper.c    | 21 ++++++++++++++++++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
index 17447c19d937..b130f7b25ea0 100644
--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -10,7 +10,9 @@
 
 /**
  * ceph_cls_lock - grab rados lock for object
- * @oid, @oloc: object to lock
+ * @osdc: osd client grabbing the lock
+ * @oid: object to lock
+ * @oloc: object to lock
  * @lock_name: the name of the lock
  * @type: lock type (CEPH_CLS_LOCK_EXCLUSIVE or CEPH_CLS_LOCK_SHARED)
  * @cookie: user-defined identifier for this instance of the lock
@@ -82,7 +84,9 @@ EXPORT_SYMBOL(ceph_cls_lock);
 
 /**
  * ceph_cls_unlock - release rados lock for object
- * @oid, @oloc: object to lock
+ * @osdc: osd client releasing the lock
+ * @oid: object to lock
+ * @oloc: object to lock
  * @lock_name: the name of the lock
  * @cookie: user-defined identifier for this instance of the lock
  */
@@ -130,7 +134,9 @@ EXPORT_SYMBOL(ceph_cls_unlock);
 
 /**
  * ceph_cls_break_lock - release rados lock for object for specified client
- * @oid, @oloc: object to lock
+ * @osdc: osd client braaking the lock
+ * @oid: object to lock
+ * @oloc: object to lock
  * @lock_name: the name of the lock
  * @cookie: user-defined identifier for this instance of the lock
  * @locker: current lock owner
diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 7057f8db4f99..1b1c09006792 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -429,7 +429,10 @@ static int is_out(const struct crush_map *map,
 /**
  * crush_choose_firstn - choose numrep distinct items of given type
  * @map: the crush_map
+ * @work: working area for a CRUSH placement computation
  * @bucket: the bucket we are choose an item from
+ * @weight: weight vector (for map leaves)
+ * @weight_max: size of weight vector
  * @x: crush input value
  * @numrep: the number of items to choose
  * @type: the type of item to choose
@@ -445,6 +448,7 @@ static int is_out(const struct crush_map *map,
  * @vary_r: pass r to recursive calls
  * @out2: second output vector for leaf items (if @recurse_to_leaf)
  * @parent_r: r value passed from the parent
+ * @choose_args: weights and ids for each known bucket
  */
 static int crush_choose_firstn(const struct crush_map *map,
 			       struct crush_work *work,
@@ -638,7 +642,22 @@ static int crush_choose_firstn(const struct crush_map *map,
 
 /**
  * crush_choose_indep: alternative breadth-first positionally stable mapping
- *
+ * @map: the crush_map
+ * @work: working area for a CRUSH placement computation
+ * @bucket: the bucket we are choose an item from
+ * @weight: weight vector (for map leaves)
+ * @weight_max: size of weight vector
+ * @x: crush input value
+ * @numrep: the number of items to choose
+ * @type: the type of item to choose
+ * @out: pointer to output vector
+ * @outpos: our position in that vector
+ * @tries: number of attempts to make
+ * @recurse_tries: number of attempts to have recursive chooseleaf make
+ * @recurse_to_leaf: true if we want one device under each item of given type (chooseleaf instead of choose)
+ * @out2: second output vector for leaf items (if @recurse_to_leaf)
+ * @parent_r: r value passed from the parent
+ * @choose_args: weights and ids for each known bucket
  */
 static void crush_choose_indep(const struct crush_map *map,
 			       struct crush_work *work,
-- 
2.28.0

