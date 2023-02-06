Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E173C68CA37
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBFXHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBFXHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:07:40 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2210B2C676;
        Mon,  6 Feb 2023 15:07:37 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P9hjw1yvPz4x1T;
        Tue,  7 Feb 2023 10:07:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675724852;
        bh=HhLHW8Jx7cFEvXyqlYCywMcEuZFrHQgia7bacaNsSJ0=;
        h=Date:From:To:Cc:Subject:From;
        b=SWrbqzoyLBpMIiJObM3D535XeXd/fvagTWBYaX5cgxQVbcMwVqAPq0UF1dkxzGvVa
         w8oppLmYSF3LcvYWbVCWe+ZaBgnXvSjubrl8VhZQnIDXSrm2a63CQM6J5u++HyAWIE
         0ml2mjHdkMkXupqrelwx7TKXG3ijarBxCL+yGVscfNJzBylosBjXMVddboZwA/6C56
         istecwk7mArbRx3kfsjbDpeDtADTQjzPyynmeyBvLNKxnv/aczU8Eq7Fjkxsvt+S7o
         1sNg7/K9oYd6pC7fUh+887A/Y/Dq7yQ2wVKqKQ3EreWxQvHYdeep6WZU8QuXRNEtX9
         +3YdHRRB0nEVA==
Date:   Tue, 7 Feb 2023 10:07:30 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Ross Zwisler <zwisler@chromium.org>,
        Ross Zwisler <zwisler@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: linux-next: manual merge of the net-next tree with the jc_docs tree
Message-ID: <20230207100730.094bd24e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rCwSGdzR.C0ZtFS8eisMTku";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/rCwSGdzR.C0ZtFS8eisMTku
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst

between commit:

  2abfcd293b79 ("docs: ftrace: always use canonical ftrace path")

from the jc_docs tree and commit:

  f2d51e579359 ("net/mlx5: Separate mlx5 driver documentation into multiple=
 pages")

from the net-next tree.

I fixed it up (I removed the file and applied the following merge fix
patch) and can carry the fix as necessary. This is now fixed as far as
linux-next is concerned, but any non trivial conflicts should be mentioned
to your upstream maintainer when your tree is submitted for merging.
You may also want to consider cooperating with the maintainer of the
conflicting tree to minimise any particularly complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 7 Feb 2023 10:04:59 +1100
Subject: [PATCH] fixup for "net/mlx5: Separate mlx5 driver documentation in=
to multiple pages"

interacting with "docs: ftrace: always use canonical ftrace path"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 .../ethernet/mellanox/mlx5/tracepoints.rst    | 104 +++++++++---------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5=
/tracepoints.rst b/Documentation/networking/device_drivers/ethernet/mellano=
x/mlx5/tracepoints.rst
index a9d3e123adc4..dc49f993c25a 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracep=
oints.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracep=
oints.rst
@@ -10,42 +10,42 @@ Tracepoints
 mlx5 driver provides internal tracepoints for tracking and debugging using
 kernel tracepoints interfaces (refer to Documentation/trace/ftrace.rst).
=20
-For the list of support mlx5 events, check `/sys/kernel/debug/tracing/even=
ts/mlx5/`.
+For the list of support mlx5 events, check `/sys/kernel/tracing/events/mlx=
5/`.
=20
 tc and eswitch offloads tracepoints:
=20
 - mlx5e_configure_flower: trace flower filter actions and cookies offloade=
d to mlx5::
=20
-    $ echo mlx5:mlx5e_configure_flower >> /sys/kernel/debug/tracing/set_ev=
ent
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5e_configure_flower >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     tc-6535  [019] ...1  2672.404466: mlx5e_configure_flower: cookie=3D000=
0000067874a55 actions=3D REDIRECT
=20
 - mlx5e_delete_flower: trace flower filter actions and cookies deleted fro=
m mlx5::
=20
-    $ echo mlx5:mlx5e_delete_flower >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5e_delete_flower >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     tc-6569  [010] .N.1  2686.379075: mlx5e_delete_flower: cookie=3D000000=
0067874a55 actions=3D NULL
=20
 - mlx5e_stats_flower: trace flower stats request::
=20
-    $ echo mlx5:mlx5e_stats_flower >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5e_stats_flower >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     tc-6546  [010] ...1  2679.704889: mlx5e_stats_flower: cookie=3D0000000=
060eb3d6a bytes=3D0 packets=3D0 lastused=3D4295560217
=20
 - mlx5e_tc_update_neigh_used_value: trace tunnel rule neigh update value o=
ffloaded to mlx5::
=20
-    $ echo mlx5:mlx5e_tc_update_neigh_used_value >> /sys/kernel/debug/trac=
ing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5e_tc_update_neigh_used_value >> /sys/kernel/tracing/se=
t_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u48:4-8806  [009] ...1 55117.882428: mlx5e_tc_update_neigh_use=
d_value: netdev: ens1f0 IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 neigh_used=3D1
=20
 - mlx5e_rep_neigh_update: trace neigh update tasks scheduled due to neigh =
state change events::
=20
-    $ echo mlx5:mlx5e_rep_neigh_update >> /sys/kernel/debug/tracing/set_ev=
ent
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5e_rep_neigh_update >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u48:7-2221  [009] ...1  1475.387435: mlx5e_rep_neigh_update: n=
etdev: ens1f0 MAC: 24:8a:07:9a:17:9a IPv4: 1.1.1.10 IPv6: ::ffff:1.1.1.10 n=
eigh_connected=3D1
=20
@@ -54,14 +54,14 @@ Bridge offloads tracepoints:
 - mlx5_esw_bridge_fdb_entry_init: trace bridge FDB entry offloaded to mlx5=
::
=20
     $ echo mlx5:mlx5_esw_bridge_fdb_entry_init >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u20:9-2217    [003] ...1   318.582243: mlx5_esw_bridge_fdb_ent=
ry_init: net_device=3Denp8s0f0_0 addr=3De4:fd:05:08:00:02 vid=3D0 flags=3D0=
 used=3D0
=20
 - mlx5_esw_bridge_fdb_entry_cleanup: trace bridge FDB entry deleted from m=
lx5::
=20
     $ echo mlx5:mlx5_esw_bridge_fdb_entry_cleanup >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     ip-2581    [005] ...1   318.629871: mlx5_esw_bridge_fdb_entry_cleanup:=
 net_device=3Denp8s0f0_1 addr=3De4:fd:05:08:00:03 vid=3D0 flags=3D0 used=3D=
16
=20
@@ -69,7 +69,7 @@ Bridge offloads tracepoints:
   mlx5::
=20
     $ echo mlx5:mlx5_esw_bridge_fdb_entry_refresh >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u20:8-3849    [003] ...1       466716: mlx5_esw_bridge_fdb_ent=
ry_refresh: net_device=3Denp8s0f0_0 addr=3De4:fd:05:08:00:02 vid=3D3 flags=
=3D0 used=3D0
=20
@@ -77,7 +77,7 @@ Bridge offloads tracepoints:
   representor::
=20
     $ echo mlx5:mlx5_esw_bridge_vlan_create >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     ip-2560    [007] ...1   318.460258: mlx5_esw_bridge_vlan_create: vid=
=3D1 flags=3D6
=20
@@ -85,7 +85,7 @@ Bridge offloads tracepoints:
   representor::
=20
     $ echo mlx5:mlx5_esw_bridge_vlan_cleanup >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     bridge-2582    [007] ...1   318.653496: mlx5_esw_bridge_vlan_cleanup: =
vid=3D2 flags=3D8
=20
@@ -93,7 +93,7 @@ Bridge offloads tracepoints:
   device::
=20
     $ echo mlx5:mlx5_esw_bridge_vport_init >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     ip-2560    [007] ...1   318.458915: mlx5_esw_bridge_vport_init: vport_=
num=3D1
=20
@@ -101,7 +101,7 @@ Bridge offloads tracepoints:
   device::
=20
     $ echo mlx5:mlx5_esw_bridge_vport_cleanup >> set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ cat /sys/kernel/tracing/trace
     ...
     ip-5387    [000] ...1       573713: mlx5_esw_bridge_vport_cleanup: vpo=
rt_num=3D1
=20
@@ -109,43 +109,43 @@ Eswitch QoS tracepoints:
=20
 - mlx5_esw_vport_qos_create: trace creation of transmit scheduler arbiter =
for vport::
=20
-    $ echo mlx5:mlx5_esw_vport_qos_create >> /sys/kernel/debug/tracing/set=
_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_esw_vport_qos_create >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     <...>-23496   [018] .... 73136.838831: mlx5_esw_vport_qos_create: (000=
0:82:00.0) vport=3D2 tsar_ix=3D4 bw_share=3D0, max_rate=3D0 group=3D0000000=
07b576bb3
=20
 - mlx5_esw_vport_qos_config: trace configuration of transmit scheduler arb=
iter for vport::
=20
-    $ echo mlx5:mlx5_esw_vport_qos_config >> /sys/kernel/debug/tracing/set=
_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_esw_vport_qos_config >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     <...>-26548   [023] .... 75754.223823: mlx5_esw_vport_qos_config: (000=
0:82:00.0) vport=3D1 tsar_ix=3D3 bw_share=3D34, max_rate=3D10000 group=3D00=
0000007b576bb3
=20
 - mlx5_esw_vport_qos_destroy: trace deletion of transmit scheduler arbiter=
 for vport::
=20
-    $ echo mlx5:mlx5_esw_vport_qos_destroy >> /sys/kernel/debug/tracing/se=
t_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_esw_vport_qos_destroy >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     <...>-27418   [004] .... 76546.680901: mlx5_esw_vport_qos_destroy: (00=
00:82:00.0) vport=3D1 tsar_ix=3D3
=20
 - mlx5_esw_group_qos_create: trace creation of transmit scheduler arbiter =
for rate group::
=20
-    $ echo mlx5:mlx5_esw_group_qos_create >> /sys/kernel/debug/tracing/set=
_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_esw_group_qos_create >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     <...>-26578   [008] .... 75776.022112: mlx5_esw_group_qos_create: (000=
0:82:00.0) group=3D000000008dac63ea tsar_ix=3D5
=20
 - mlx5_esw_group_qos_config: trace configuration of transmit scheduler arb=
iter for rate group::
=20
-    $ echo mlx5:mlx5_esw_group_qos_config >> /sys/kernel/debug/tracing/set=
_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_esw_group_qos_config >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     <...>-27303   [020] .... 76461.455356: mlx5_esw_group_qos_config: (000=
0:82:00.0) group=3D000000008dac63ea tsar_ix=3D5 bw_share=3D100 max_rate=3D2=
0000
=20
 - mlx5_esw_group_qos_destroy: trace deletion of transmit scheduler arbiter=
 for group::
=20
-    $ echo mlx5:mlx5_esw_group_qos_destroy >> /sys/kernel/debug/tracing/se=
t_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_esw_group_qos_destroy >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     <...>-27418   [006] .... 76547.187258: mlx5_esw_group_qos_destroy: (00=
00:82:00.0) group=3D000000007b576bb3 tsar_ix=3D1
=20
@@ -153,77 +153,77 @@ SF tracepoints:
=20
 - mlx5_sf_add: trace addition of the SF port::
=20
-    $ echo mlx5:mlx5_sf_add >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_add >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     devlink-9363    [031] ..... 24610.188722: mlx5_sf_add: (0000:06:00.0) =
port_index=3D32768 controller=3D0 hw_id=3D0x8000 sfnum=3D88
=20
 - mlx5_sf_free: trace freeing of the SF port::
=20
-    $ echo mlx5:mlx5_sf_free >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_free >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     devlink-9830    [038] ..... 26300.404749: mlx5_sf_free: (0000:06:00.0)=
 port_index=3D32768 controller=3D0 hw_id=3D0x8000
=20
 - mlx5_sf_activate: trace activation of the SF port::
=20
-    $ echo mlx5:mlx5_sf_activate >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_activate >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     devlink-29841   [008] .....  3669.635095: mlx5_sf_activate: (0000:08:0=
0.0) port_index=3D32768 controller=3D0 hw_id=3D0x8000
=20
 - mlx5_sf_deactivate: trace deactivation of the SF port::
=20
-    $ echo mlx5:mlx5_sf_deactivate >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_deactivate >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     devlink-29994   [008] .....  4015.969467: mlx5_sf_deactivate: (0000:08=
:00.0) port_index=3D32768 controller=3D0 hw_id=3D0x8000
=20
 - mlx5_sf_hwc_alloc: trace allocating of the hardware SF context::
=20
-    $ echo mlx5:mlx5_sf_hwc_alloc >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_hwc_alloc >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     devlink-9775    [031] ..... 26296.385259: mlx5_sf_hwc_alloc: (0000:06:=
00.0) controller=3D0 hw_id=3D0x8000 sfnum=3D88
=20
 - mlx5_sf_hwc_free: trace freeing of the hardware SF context::
=20
-    $ echo mlx5:mlx5_sf_hwc_free >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_hwc_free >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u128:3-9093    [046] ..... 24625.365771: mlx5_sf_hwc_free: (00=
00:06:00.0) hw_id=3D0x8000
=20
 - mlx5_sf_hwc_deferred_free: trace deferred freeing of the hardware SF con=
text::
=20
-    $ echo mlx5:mlx5_sf_hwc_deferred_free >> /sys/kernel/debug/tracing/set=
_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_hwc_deferred_free >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     devlink-9519    [046] ..... 24624.400271: mlx5_sf_hwc_deferred_free: (=
0000:06:00.0) hw_id=3D0x8000
=20
 - mlx5_sf_update_state: trace state updates for SF contexts::
=20
-    $ echo mlx5:mlx5_sf_update_state >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_update_state >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u20:3-29490   [009] .....  4141.453530: mlx5_sf_update_state: =
(0000:08:00.0) port_index=3D32768 controller=3D0 hw_id=3D0x8000 state=3D2
=20
 - mlx5_sf_vhca_event: trace SF vhca event and state::
=20
-    $ echo mlx5:mlx5_sf_vhca_event >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_vhca_event >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u128:3-9093    [046] ..... 24625.365525: mlx5_sf_vhca_event: (=
0000:06:00.0) hw_id=3D0x8000 sfnum=3D88 vhca_state=3D1
=20
 - mlx5_sf_dev_add: trace SF device add event::
=20
-    $ echo mlx5:mlx5_sf_dev_add>> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_dev_add>> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u128:3-9093    [000] ..... 24616.524495: mlx5_sf_dev_add: (000=
0:06:00.0) sfdev=3D00000000fc5d96fd aux_id=3D4 hw_id=3D0x8000 sfnum=3D88
=20
 - mlx5_sf_dev_del: trace SF device delete event::
=20
-    $ echo mlx5:mlx5_sf_dev_del >> /sys/kernel/debug/tracing/set_event
-    $ cat /sys/kernel/debug/tracing/trace
+    $ echo mlx5:mlx5_sf_dev_del >> /sys/kernel/tracing/set_event
+    $ cat /sys/kernel/tracing/trace
     ...
     kworker/u128:3-9093    [044] ..... 24624.400749: mlx5_sf_dev_del: (000=
0:06:00.0) sfdev=3D00000000fc5d96fd aux_id=3D4 hw_id=3D0x8000 sfnum=3D88
--=20
2.35.1

--=20
Cheers,
Stephen Rothwell

--Sig_/rCwSGdzR.C0ZtFS8eisMTku
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPhiDIACgkQAVBC80lX
0GxlqAgAjnxlSKJD7qjD6suKgudL8J3QAnNLK5SJiWwzKg7rekpUXw/OZjhYbZ56
9Y++aujpE+/FW8QfHvelAdEyDmEx4zoUcdoD0IxK9gYOl0N7mWfjx/J3PBxxQsW2
DqQlDXhp/2UPO006SiUQ8aJUZO5bri2uR6Hq6ZGLn6dkN1lH1qIH4jaSYQVyv9j/
v/aW3C2tlpXcC9LImbkzERnKaHk3+zxZ7STgBNB1PP0XhpuqMTXjH8X0pYzAmTQZ
VaUEk0b6IX4WAq5nOUWnWmiPoGgBdvqgfCKnTimcIq+ZlFcNPH6VDe9tgHvq0qtj
azeprz3JuL9SnuBbXqgmb98Dla6aeA==
=8tZ4
-----END PGP SIGNATURE-----

--Sig_/rCwSGdzR.C0ZtFS8eisMTku--
