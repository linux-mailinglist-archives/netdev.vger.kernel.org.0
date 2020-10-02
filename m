Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C102819F4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388566AbgJBRln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:41:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48915 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388397AbgJBRlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 13:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601660495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SZfKS56kyS61FQ2o94ojIO5oFVZIXcJU5Ns/OLOvzQs=;
        b=ZvFP32TYFChR5NiklsehHbveae8i6XDvKaJJgk2cBLG9mgRKFG5sr/WeW6lpqxl7aCGkUD
        +iQgOwwtFH99hhmjUfDCQ4QYiwWtbHABmUORKmIN9mEhxa7XZBDuPTmq2EdJCWE3pqF/e/
        TD1BDvgVXLfZqXcGBIsUQdrGtOzA1YQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-h9JmcIhONVS7LWvjCaRHoA-1; Fri, 02 Oct 2020 13:41:32 -0400
X-MC-Unique: h9JmcIhONVS7LWvjCaRHoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F5B310309B6;
        Fri,  2 Oct 2020 17:41:20 +0000 (UTC)
Received: from hpe-dl360pgen9-01.klab.eng.bos.redhat.com (hpe-dl360pgen9-01.klab.eng.bos.redhat.com [10.16.160.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B294910016DA;
        Fri,  2 Oct 2020 17:41:06 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 5/6] bonding: update Documentation for port/bond terminology
Date:   Fri,  2 Oct 2020 13:40:00 -0400
Message-Id: <20201002174001.3012643-6-jarod@redhat.com>
In-Reply-To: <20201002174001.3012643-1-jarod@redhat.com>
References: <20201002174001.3012643-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Point users to the new interface names instead of the old ones, where
appropriate. Userspace bits referenced still include use of master/slave,
but those can't be altered until userspace changes too, ideally after
these changes propagate to the community at large.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 Documentation/networking/bonding.rst | 440 +++++++++++++--------------
 1 file changed, 220 insertions(+), 220 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index adc314639085..f4c4f0fae83b 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -167,22 +167,22 @@ or, for backwards compatibility, the option value.  E.g.,
 
 The parameters are as follows:
 
-active_slave
+active_port
 
-	Specifies the new active slave for modes that support it
+	Specifies the new active port for modes that support it
 	(active-backup, balance-alb and balance-tlb).  Possible values
-	are the name of any currently enslaved interface, or an empty
-	string.  If a name is given, the slave and its link must be up in order
-	to be selected as the new active slave.  If an empty string is
-	specified, the current active slave is cleared, and a new active
-	slave is selected automatically.
+	are the name of any currently aggregated interface, or an empty
+	string.  If a name is given, the port and its port must be up in order
+	to be selected as the new active port.  If an empty string is
+	specified, the current active port is cleared, and a new active
+	port is selected automatically.
 
 	Note that this is only available through the sysfs interface. No module
 	parameter by this name exists.
 
 	The normal value of this option is the name of the currently
-	active slave, or the empty string if there is no active slave or
-	the current mode does not use an active slave.
+	active port, or the empty string if there is no active port or
+	the current mode does not use an active port.
 
 ad_actor_sys_prio
 
@@ -199,8 +199,8 @@ ad_actor_system
 	protocol packet exchanges (LACPDUs). The value cannot be NULL or
 	multicast. It is preferred to have the local-admin bit set for this
 	mac but driver does not enforce it. If the value is not given then
-	system defaults to using the masters' mac address as actors' system
-	address.
+	system defaults to using the bonds' mac address as actors'
+	system address.
 
 	This parameter has effect only in 802.3ad mode and is available through
 	SysFs interface.
@@ -216,8 +216,8 @@ ad_select
 		bandwidth.
 
 		Reselection of the active aggregator occurs only when all
-		slaves of the active aggregator are down or the active
-		aggregator has no slaves.
+		ports of the active aggregator are down or the active
+		aggregator has no ports.
 
 		This is the default value.
 
@@ -226,18 +226,18 @@ ad_select
 		The active aggregator is chosen by largest aggregate
 		bandwidth.  Reselection occurs if:
 
-		- A slave is added to or removed from the bond
+		- A port is added to or removed from the bond
 
-		- Any slave's link state changes
+		- Any port's link state changes
 
-		- Any slave's 802.3ad association state changes
+		- Any port's 802.3ad association state changes
 
 		- The bond's administrative state changes to up
 
 	count or 2
 
 		The active aggregator is chosen by the largest number of
-		ports (slaves).  Reselection occurs as described under the
+		ports (ports).  Reselection occurs as described under the
 		"bandwidth" setting, above.
 
 	The bandwidth and count selection policies permit failover of
@@ -265,7 +265,7 @@ ad_user_port_key
 	This parameter has effect only in 802.3ad mode and is available through
 	SysFs interface.
 
-all_slaves_active
+all_ports_active
 
 	Specifies that duplicate frames (received on inactive ports) should be
 	dropped (0) or delivered (1).
@@ -281,10 +281,10 @@ arp_interval
 
 	Specifies the ARP link monitoring frequency in milliseconds.
 
-	The ARP monitor works by periodically checking the slave
+	The ARP monitor works by periodically checking the port
 	devices to determine whether they have sent or received
 	traffic recently (the precise criteria depends upon the
-	bonding mode, and the state of the slave).  Regular traffic is
+	bonding mode, and the state of the port).  Regular traffic is
 	generated via ARP probes issued for the addresses specified by
 	the arp_ip_target option.
 
@@ -327,50 +327,50 @@ arp_validate
 
 	active or 1
 
-		Validation is performed only for the active slave.
+		Validation is performed only for the active port.
 
 	backup or 2
 
-		Validation is performed only for backup slaves.
+		Validation is performed only for backup ports.
 
 	all or 3
 
-		Validation is performed for all slaves.
+		Validation is performed for all ports.
 
 	filter or 4
 
-		Filtering is applied to all slaves. No validation is
+		Filtering is applied to all ports. No validation is
 		performed.
 
 	filter_active or 5
 
-		Filtering is applied to all slaves, validation is performed
-		only for the active slave.
+		Filtering is applied to all ports, validation is performed
+		only for the active port.
 
 	filter_backup or 6
 
-		Filtering is applied to all slaves, validation is performed
-		only for backup slaves.
+		Filtering is applied to all ports, validation is performed
+		only for backup ports.
 
 	Validation:
 
 	Enabling validation causes the ARP monitor to examine the incoming
-	ARP requests and replies, and only consider a slave to be up if it
+	ARP requests and replies, and only consider a port to be up if it
 	is receiving the appropriate ARP traffic.
 
-	For an active slave, the validation checks ARP replies to confirm
-	that they were generated by an arp_ip_target.  Since backup slaves
+	For an active port, the validation checks ARP replies to confirm
+	that they were generated by an arp_ip_target.  Since backup ports
 	do not typically receive these replies, the validation performed
-	for backup slaves is on the broadcast ARP request sent out via the
-	active slave.  It is possible that some switch or network
-	configurations may result in situations wherein the backup slaves
+	for backup ports is on the broadcast ARP request sent out via the
+	active port.  It is possible that some switch or network
+	configurations may result in situations wherein the backup ports
 	do not receive the ARP requests; in such a situation, validation
-	of backup slaves must be disabled.
+	of backup ports must be disabled.
 
-	The validation of ARP requests on backup slaves is mainly helping
-	bonding to decide which slaves are more likely to work in case of
-	the active slave failure, it doesn't really guarantee that the
-	backup slave will work if it's selected as the next active slave.
+	The validation of ARP requests on backup ports is mainly helping
+	bonding to decide which ports are more likely to work in case of
+	the active port failure, it doesn't really guarantee that the
+	backup port will work if it's selected as the next active port.
 
 	Validation is useful in network configurations in which multiple
 	bonding hosts are concurrently issuing ARPs to one or more targets
@@ -387,11 +387,11 @@ arp_validate
 	Enabling filtering causes the ARP monitor to only use incoming ARP
 	packets for link availability purposes.  Arriving packets that are
 	not ARPs are delivered normally, but do not count when determining
-	if a slave is available.
+	if a port is available.
 
 	Filtering operates by only considering the reception of ARP
 	packets (any ARP packet, regardless of source or destination) when
-	determining if a slave has received traffic for link availability
+	determining if a port has received traffic for link availability
 	purposes.
 
 	Filtering is useful in network configurations in which significant
@@ -405,26 +405,26 @@ arp_validate
 arp_all_targets
 
 	Specifies the quantity of arp_ip_targets that must be reachable
-	in order for the ARP monitor to consider a slave as being up.
-	This option affects only active-backup mode for slaves with
+	in order for the ARP monitor to consider a port as being up.
+	This option affects only active-backup mode for ports with
 	arp_validation enabled.
 
 	Possible values are:
 
 	any or 0
 
-		consider the slave up only when any of the arp_ip_targets
+		consider the port up only when any of the arp_ip_targets
 		is reachable
 
 	all or 1
 
-		consider the slave up only when all of the arp_ip_targets
+		consider the port up only when all of the arp_ip_targets
 		are reachable
 
 downdelay
 
 	Specifies the time, in milliseconds, to wait before disabling
-	a slave after a link failure has been detected.  This option
+	a port after a link failure has been detected.  This option
 	is only valid for the miimon link monitor.  The downdelay
 	value should be a multiple of the miimon value; if not, it
 	will be rounded down to the nearest multiple.  The default
@@ -432,8 +432,8 @@ downdelay
 
 fail_over_mac
 
-	Specifies whether active-backup mode should set all slaves to
-	the same MAC address at enslavement (the traditional
+	Specifies whether active-backup mode should set all ports to
+	the same MAC address at connection (the traditional
 	behavior), or, when enabled, perform special handling of the
 	bond's MAC address in accordance with the selected policy.
 
@@ -442,16 +442,16 @@ fail_over_mac
 	none or 0
 
 		This setting disables fail_over_mac, and causes
-		bonding to set all slaves of an active-backup bond to
-		the same MAC address at enslavement time.  This is the
+		bonding to set all ports of an active-backup bond to
+		the same MAC address at connection time.  This is the
 		default.
 
 	active or 1
 
 		The "active" fail_over_mac policy indicates that the
 		MAC address of the bond should always be the MAC
-		address of the currently active slave.  The MAC
-		address of the slaves is not changed; instead, the MAC
+		address of the currently active port.  The MAC
+		address of the ports is not changed; instead, the MAC
 		address of the bond changes during a failover.
 
 		This policy is useful for devices that cannot ever
@@ -478,12 +478,12 @@ fail_over_mac
 
 		The "follow" fail_over_mac policy causes the MAC
 		address of the bond to be selected normally (normally
-		the MAC address of the first slave added to the bond).
-		However, the second and subsequent slaves are not set
+		the MAC address of the first port added to the bond).
+		However, the second and subsequent ports are not set
 		to this MAC address while they are in a backup role; a
-		slave is programmed with the bond's MAC address at
-		failover time (and the formerly active slave receives
-		the newly active slave's MAC address).
+		port is programmed with the bond's MAC address at
+		failover time (and the formerly active port receives
+		the newly active port's MAC address).
 
 		This policy is useful for multiport devices that
 		either become confused or incur a performance penalty
@@ -491,11 +491,11 @@ fail_over_mac
 		address.
 
 
-	The default policy is none, unless the first slave cannot
+	The default policy is none, unless the first port cannot
 	change its MAC address, in which case the active policy is
 	selected by default.
 
-	This option may be modified via sysfs only when no slaves are
+	This option may be modified via sysfs only when no ports are
 	present in the bond.
 
 	This option was added in bonding version 3.2.0.  The "follow"
@@ -526,7 +526,7 @@ max_bonds
 miimon
 
 	Specifies the MII link monitoring frequency in milliseconds.
-	This determines how often the link state of each slave is
+	This determines how often the link state of each port is
 	inspected for link failures.  A value of zero disables MII
 	link monitoring.  A value of 100 is a good starting point.
 	The use_carrier option, below, affects how the link state is
@@ -558,22 +558,22 @@ mode
 	balance-rr or 0
 
 		Round-robin policy: Transmit packets in sequential
-		order from the first available slave through the
+		order from the first available port through the
 		last.  This mode provides load balancing and fault
 		tolerance.
 
 	active-backup or 1
 
-		Active-backup policy: Only one slave in the bond is
-		active.  A different slave becomes active if, and only
-		if, the active slave fails.  The bond's MAC address is
+		Active-backup policy: Only one port in the bond is
+		active.  A different port becomes active if, and only
+		if, the active port fails.  The bond's MAC address is
 		externally visible on only one port (network adapter)
 		to avoid confusing the switch.
 
 		In bonding version 2.6.2 or later, when a failover
 		occurs in active-backup mode, bonding will issue one
-		or more gratuitous ARPs on the newly active slave.
-		One gratuitous ARP is issued for the bonding master
+		or more gratuitous ARPs on the newly active port.
+		One gratuitous ARP is issued for the bonding device
 		interface and each VLAN interfaces configured above
 		it, provided that the interface has at least one IP
 		address configured.  Gratuitous ARPs issued for VLAN
@@ -588,7 +588,7 @@ mode
 		XOR policy: Transmit based on the selected transmit
 		hash policy.  The default policy is a simple [(source
 		MAC address XOR'd with destination MAC address XOR
-		packet type ID) modulo slave count].  Alternate transmit
+		packet type ID) modulo port count].  Alternate transmit
 		policies may be	selected via the xmit_hash_policy option,
 		described below.
 
@@ -596,17 +596,17 @@ mode
 
 	broadcast or 3
 
-		Broadcast policy: transmits everything on all slave
+		Broadcast policy: transmits everything on all port
 		interfaces.  This mode provides fault tolerance.
 
 	802.3ad or 4
 
 		IEEE 802.3ad Dynamic link aggregation.  Creates
 		aggregation groups that share the same speed and
-		duplex settings.  Utilizes all slaves in the active
+		duplex settings.  Utilizes all ports in the active
 		aggregator according to the 802.3ad specification.
 
-		Slave selection for outgoing traffic is done according
+		Port selection for outgoing traffic is done according
 		to the transmit hash policy, which may be changed from
 		the default simple XOR policy via the xmit_hash_policy
 		option, documented below.  Note that not all transmit
@@ -619,7 +619,7 @@ mode
 		Prerequisites:
 
 		1. Ethtool support in the base drivers for retrieving
-		the speed and duplex of each slave.
+		the speed and duplex of each port.
 
 		2. A switch that supports IEEE 802.3ad Dynamic link
 		aggregation.
@@ -634,20 +634,20 @@ mode
 
 		In tlb_dynamic_lb=1 mode; the outgoing traffic is
 		distributed according to the current load (computed
-		relative to the speed) on each slave.
+		relative to the speed) on each port.
 
 		In tlb_dynamic_lb=0 mode; the load balancing based on
 		current load is disabled and the load is distributed
 		only using the hash distribution.
 
-		Incoming traffic is received by the current slave.
-		If the receiving slave fails, another slave takes over
-		the MAC address of the failed receiving slave.
+		Incoming traffic is received by the current port.
+		If the receiving port fails, another port takes over
+		the MAC address of the failed receiving port.
 
 		Prerequisite:
 
 		Ethtool support in the base drivers for retrieving the
-		speed of each slave.
+		speed of each port.
 
 	balance-alb or 6
 
@@ -658,7 +658,7 @@ mode
 		The bonding driver intercepts the ARP Replies sent by
 		the local system on their way out and overwrites the
 		source hardware address with the unique hardware
-		address of one of the slaves in the bond such that
+		address of one of the ports in the bond such that
 		different peers use different hardware addresses for
 		the server.
 
@@ -668,24 +668,24 @@ mode
 		IP information from the ARP packet.  When the ARP
 		Reply arrives from the peer, its hardware address is
 		retrieved and the bonding driver initiates an ARP
-		reply to this peer assigning it to one of the slaves
+		reply to this peer assigning it to one of the ports
 		in the bond.  A problematic outcome of using ARP
 		negotiation for balancing is that each time that an
 		ARP request is broadcast it uses the hardware address
 		of the bond.  Hence, peers learn the hardware address
 		of the bond and the balancing of receive traffic
-		collapses to the current slave.  This is handled by
+		collapses to the current port.  This is handled by
 		sending updates (ARP Replies) to all the peers with
 		their individually assigned hardware address such that
 		the traffic is redistributed.  Receive traffic is also
-		redistributed when a new slave is added to the bond
-		and when an inactive slave is re-activated.  The
+		redistributed when a new port is added to the bond
+		and when an inactive port is re-activated.  The
 		receive load is distributed sequentially (round robin)
-		among the group of highest speed slaves in the bond.
+		among the group of highest speed ports in the bond.
 
-		When a link is reconnected or a new slave joins the
+		When a link is reconnected or a new port joins the
 		bond the receive traffic is redistributed among all
-		active slaves in the bond by initiating ARP Replies
+		active ports in the bond by initiating ARP Replies
 		with the selected MAC address to each of the
 		clients. The updelay parameter (detailed below) must
 		be set to a value equal or greater than the switch's
@@ -695,16 +695,16 @@ mode
 		Prerequisites:
 
 		1. Ethtool support in the base drivers for retrieving
-		the speed of each slave.
+		the speed of each port.
 
 		2. Base driver support for setting the hardware
 		address of a device while it is open.  This is
-		required so that there will always be one slave in the
+		required so that there will always be one port in the
 		team using the bond hardware address (the
-		curr_active_slave) while having a unique hardware
-		address for each slave in the bond.  If the
-		curr_active_slave fails its hardware address is
-		swapped with the new curr_active_slave that was
+		curr_active_port) while having a unique hardware
+		address for each port in the bond.  If the
+		curr_active_port fails its hardware address is
+		swapped with the new curr_active_port that was
 		chosen.
 
 num_grat_arp,
@@ -712,7 +712,7 @@ num_unsol_na
 
 	Specify the number of peer notifications (gratuitous ARPs and
 	unsolicited IPv6 Neighbor Advertisements) to be issued after a
-	failover event.  As soon as the link is up on the new slave
+	failover event.  As soon as the link is up on the new port
 	(possibly immediately) a peer notification is sent on the
 	bonding device and each VLAN sub-device. This is repeated at
 	the rate specified by peer_notif_delay if the number is
@@ -726,10 +726,10 @@ num_unsol_na
 	are generated by the ipv4 and ipv6 code and the numbers of
 	repetitions cannot be set independently.
 
-packets_per_slave
+packets_per_port
 
-	Specify the number of packets to transmit through a slave before
-	moving to the next one. When set to 0 then a slave is chosen at
+	Specify the number of packets to transmit through a port before
+	moving to the next one. When set to 0 then a port is chosen at
 	random.
 
 	The valid range is 0 - 65535; the default value is 1. This option
@@ -747,11 +747,11 @@ peer_notif_delay
 
 primary
 
-	A string (eth0, eth2, etc) specifying which slave is the
+	A string (eth0, eth2, etc) specifying which port is the
 	primary device.  The specified device will always be the
-	active slave while it is available.  Only when the primary is
+	active port while it is available.  Only when the primary is
 	off-line will alternate devices be used.  This is useful when
-	one slave is preferred over another, e.g., when one slave has
+	one port is preferred over another, e.g., when one port has
 	higher throughput than another.
 
 	The primary option is only valid for active-backup(1),
@@ -759,41 +759,41 @@ primary
 
 primary_reselect
 
-	Specifies the reselection policy for the primary slave.  This
-	affects how the primary slave is chosen to become the active slave
-	when failure of the active slave or recovery of the primary slave
+	Specifies the reselection policy for the primary port.  This
+	affects how the primary port is chosen to become the active port
+	when failure of the active port or recovery of the primary port
 	occurs.  This option is designed to prevent flip-flopping between
-	the primary slave and other slaves.  Possible values are:
+	the primary port and other ports.  Possible values are:
 
 	always or 0 (default)
 
-		The primary slave becomes the active slave whenever it
+		The primary port becomes the active port whenever it
 		comes back up.
 
 	better or 1
 
-		The primary slave becomes the active slave when it comes
-		back up, if the speed and duplex of the primary slave is
+		The primary port becomes the active port when it comes
+		back up, if the speed and duplex of the primary port is
 		better than the speed and duplex of the current active
-		slave.
+		port.
 
 	failure or 2
 
-		The primary slave becomes the active slave only if the
-		current active slave fails and the primary slave is up.
+		The primary port becomes the active port only if the
+		current active port fails and the primary port is up.
 
 	The primary_reselect setting is ignored in two cases:
 
-		If no slaves are active, the first slave to recover is
-		made the active slave.
+		If no ports are active, the first port to recover is
+		made the active port.
 
-		When initially enslaved, the primary slave is always made
-		the active slave.
+		When initially connected, the primary port is always made
+		the active port.
 
 	Changing the primary_reselect policy via sysfs will cause an
-	immediate selection of the best active slave according to the new
+	immediate selection of the best active port according to the new
 	policy.  This may or may not result in a change of the active
-	slave, depending upon the circumstances.
+	port, depending upon the circumstances.
 
 	This option was added for bonding version 3.6.0.
 
@@ -803,7 +803,7 @@ tlb_dynamic_lb
 	mode. The value has no effect on any other modes.
 
 	The default behavior of tlb mode is to shuffle active flows across
-	slaves based on the load in that interval. This gives nice lb
+	ports based on the load in that interval. This gives nice lb
 	characteristics but can cause packet reordering. If re-ordering is
 	a concern use this variable to disable flow shuffling and rely on
 	load balancing provided solely by the hash distribution.
@@ -822,7 +822,7 @@ tlb_dynamic_lb
 updelay
 
 	Specifies the time, in milliseconds, to wait before enabling a
-	slave after a link recovery has been detected.  This option is
+	port after a link recovery has been detected.  This option is
 	only valid for the miimon link monitor.  The updelay value
 	should be a multiple of the miimon value; if not, it will be
 	rounded down to the nearest multiple.  The default value is 0.
@@ -851,7 +851,7 @@ use_carrier
 
 xmit_hash_policy
 
-	Selects the transmit hash policy to use for slave selection in
+	Selects the transmit hash policy to use for port selection in
 	balance-xor, 802.3ad, and tlb modes.  Possible values are:
 
 	layer2
@@ -860,10 +860,10 @@ xmit_hash_policy
 		field to generate the hash. The formula is
 
 		hash = source MAC XOR destination MAC XOR packet type ID
-		slave number = hash modulo slave count
+		port number = hash modulo port count
 
 		This algorithm will place all traffic to a particular
-		network peer on the same slave.
+		network peer on the same port.
 
 		This algorithm is 802.3ad compliant.
 
@@ -879,13 +879,13 @@ xmit_hash_policy
 		hash = hash XOR source IP XOR destination IP
 		hash = hash XOR (hash RSHIFT 16)
 		hash = hash XOR (hash RSHIFT 8)
-		And then hash is reduced modulo slave count.
+		And then hash is reduced modulo port count.
 
 		If the protocol is IPv6 then the source and destination
 		addresses are first hashed using ipv6_addr_hash.
 
 		This algorithm will place all traffic to a particular
-		network peer on the same slave.  For non-IP traffic,
+		network peer on the same port.  For non-IP traffic,
 		the formula is the same as for the layer2 transmit
 		hash policy.
 
@@ -901,8 +901,8 @@ xmit_hash_policy
 		This policy uses upper layer protocol information,
 		when available, to generate the hash.  This allows for
 		traffic to a particular network peer to span multiple
-		slaves, although a single connection will not span
-		multiple slaves.
+		ports, although a single connection will not span
+		multiple ports.
 
 		The formula for unfragmented TCP and UDP packets is
 
@@ -910,7 +910,7 @@ xmit_hash_policy
 		hash = hash XOR source IP XOR destination IP
 		hash = hash XOR (hash RSHIFT 16)
 		hash = hash XOR (hash RSHIFT 8)
-		And then hash is reduced modulo slave count.
+		And then hash is reduced modulo port count.
 
 		If the protocol is IPv6 then the source and destination
 		addresses are first hashed using ipv6_addr_hash.
@@ -968,16 +968,16 @@ resend_igmp
 
 	This option is useful for bonding modes balance-rr (0), active-backup
 	(1), balance-tlb (5) and balance-alb (6), in which a failover can
-	switch the IGMP traffic from one slave to another.  Therefore a fresh
+	switch the IGMP traffic from one port to another.  Therefore a fresh
 	IGMP report must be issued to cause the switch to forward the incoming
-	IGMP traffic over the newly selected slave.
+	IGMP traffic over the newly selected port.
 
 	This option was added for bonding version 3.7.0.
 
 lp_interval
 
 	Specifies the number of seconds between instances where the bonding
-	driver sends learning packets to each slaves peer switch.
+	driver sends learning packets to each ports peer switch.
 
 	The valid range is 1 - 0x7fffffff; the default value is 1. This Option
 	has effect only in balance-tlb and balance-alb modes.
@@ -1034,9 +1034,9 @@ front end does not provide any means to work with bonding devices.
 Bonding devices can be managed by hand, however, as follows.
 
 First, if they have not already been configured, configure the
-slave devices.  On SLES 9, this is most easily done by running the
+port devices.  On SLES 9, this is most easily done by running the
 yast2 sysconfig configuration utility.  The goal is for to create an
-ifcfg-id file for each slave device.  The simplest way to accomplish
+ifcfg-id file for each port device.  The simplest way to accomplish
 this is to configure the devices for DHCP (this is only to get the
 file ifcfg-id file created; see below for some issues with DHCP).  The
 name of the configuration file for each device will be of the form::
@@ -1047,8 +1047,8 @@ Where the "xx" portion will be replaced with the digits from
 the device's permanent MAC address.
 
 Once the set of ifcfg-id-xx:xx:xx:xx:xx:xx files has been
-created, it is necessary to edit the configuration files for the slave
-devices (the MAC addresses correspond to those of the slave devices).
+created, it is necessary to edit the configuration files for the port
+devices (the MAC addresses correspond to those of the port devices).
 Before editing, the file will contain multiple lines, and will look
 something like this::
 
@@ -1111,7 +1111,7 @@ The possible values are:
 	======== ======================================================
 
 The line BONDING_MASTER='yes' indicates that the device is a
-bonding master device.  The only useful value is "yes."
+bonding aggregator device.  The only useful value is "yes."
 
 The contents of BONDING_MODULE_OPTS are supplied to the
 instance of the bonding module for this device.  Specify the options
@@ -1119,9 +1119,9 @@ for the bonding mode, link monitoring, and so on here.  Do not include
 the max_bonds bonding parameter; this will confuse the configuration
 system if you have multiple bonding devices.
 
-Finally, supply one BONDING_SLAVEn="slave device" for each
-slave.  where "n" is an increasing value, one for each slave.  The
-"slave device" is either an interface name, e.g., "eth0", or a device
+Finally, supply one BONDING_SLAVEn="port device" for each
+port.  where "n" is an increasing value, one for each port.  The
+"port device" is either an interface name, e.g., "eth0", or a device
 specifier for the network device.  The interface name is easier to
 find, but the ethN names are subject to change at boot time if, e.g.,
 a device early in the sequence has failed.  The device specifiers
@@ -1129,7 +1129,7 @@ a device early in the sequence has failed.  The device specifiers
 network device, and will not change unless the device's bus location
 changes (for example, it is moved from one PCI slot to another).  The
 example above uses one of each type for demonstration purposes; most
-configurations will choose one or the other for all slave devices.
+configurations will choose one or the other for all port devices.
 
 When all configuration files have been modified or created,
 networking must be restarted for the configuration changes to take
@@ -1162,7 +1162,7 @@ Under sysconfig, configuring a device with BOOTPROTO='dhcp'
 will cause it to query DHCP for its IP address information.  At this
 writing, this does not function for bonding devices; the scripts
 attempt to obtain the device address from DHCP prior to adding any of
-the slave devices.  Without active slaves, the DHCP requests are not
+the port devices.  Without active ports, the DHCP requests are not
 sent to the network.
 
 3.1.2 Configuring Multiple Bonds with Sysconfig
@@ -1440,15 +1440,15 @@ Creating and Destroying Bonds
 -----------------------------
 To add a new bond foo::
 
-	# echo +foo > /sys/class/net/bonding_masters
+	# echo +foo > /sys/class/net/bonding_bonds
 
 To remove an existing bond bar::
 
-	# echo -bar > /sys/class/net/bonding_masters
+	# echo -bar > /sys/class/net/bonding_bonds
 
 To show all existing bonds::
 
-	# cat /sys/class/net/bonding_masters
+	# cat /sys/class/net/bonding_bonds
 
 .. note::
 
@@ -1458,28 +1458,28 @@ To show all existing bonds::
 
 Adding and Removing Slaves
 --------------------------
-Interfaces may be enslaved to a bond using the file
-/sys/class/net/<bond>/bonding/slaves.  The semantics for this file
-are the same as for the bonding_masters file.
+Interfaces may be connected to a bond using the file
+/sys/class/net/<bond>/bonding/ports.  The semantics for this file
+are the same as for the bonding_bonds file.
 
-To enslave interface eth0 to bond bond0::
+To connect interface eth0 to bond bond0::
 
 	# ifconfig bond0 up
-	# echo +eth0 > /sys/class/net/bond0/bonding/slaves
+	# echo +eth0 > /sys/class/net/bond0/bonding/ports
 
-To free slave eth0 from bond bond0::
+To free port eth0 from bond bond0::
 
-	# echo -eth0 > /sys/class/net/bond0/bonding/slaves
+	# echo -eth0 > /sys/class/net/bond0/bonding/ports
 
-When an interface is enslaved to a bond, symlinks between the
+When an interface is connected to a bond, symlinks between the
 two are created in the sysfs filesystem.  In this case, you would get
-/sys/class/net/bond0/slave_eth0 pointing to /sys/class/net/eth0, and
+/sys/class/net/bond0/lower_eth0 pointing to /sys/class/net/eth0, and
 /sys/class/net/eth0/master pointing to /sys/class/net/bond0.
 
 This means that you can tell quickly whether or not an
-interface is enslaved by looking for the master symlink.  Thus:
-# echo -eth0 > /sys/class/net/eth0/master/bonding/slaves
-will free eth0 from whatever bond it is enslaved to, regardless of
+interface is connected by looking for the master symlink.  Thus:
+# echo -eth0 > /sys/class/net/eth0/master/bonding/ports
+will free eth0 from whatever bond it is connected to, regardless of
 the name of the bond interface.
 
 Changing a Bond's Configuration
@@ -1536,7 +1536,7 @@ To configure the interval between learning packet transmits::
 .. note::
 
    the lp_interval is the number of seconds between instances where
-   the bonding driver sends learning packets to each slaves peer switch.  The
+   the bonding driver sends learning packets to each port's peer switch.  The
    default interval is 1 second.
 
 Example Configuration
@@ -1554,21 +1554,21 @@ following::
 	echo balance-alb > /sys/class/net/bond0/bonding/mode
 	ifconfig bond0 192.168.1.1 netmask 255.255.255.0 up
 	echo 100 > /sys/class/net/bond0/bonding/miimon
-	echo +eth0 > /sys/class/net/bond0/bonding/slaves
-	echo +eth1 > /sys/class/net/bond0/bonding/slaves
+	echo +eth0 > /sys/class/net/bond0/bonding/ports
+	echo +eth1 > /sys/class/net/bond0/bonding/ports
 
 To add a second bond, with two e1000 interfaces in
 active-backup mode, using ARP monitoring, add the following lines to
 your init script::
 
 	modprobe e1000
-	echo +bond1 > /sys/class/net/bonding_masters
+	echo +bond1 > /sys/class/net/bonding_bonds
 	echo active-backup > /sys/class/net/bond1/bonding/mode
 	ifconfig bond1 192.168.2.1 netmask 255.255.255.0 up
 	echo +192.168.2.100 /sys/class/net/bond1/bonding/arp_ip_target
 	echo 2000 > /sys/class/net/bond1/bonding/arp_interval
-	echo +eth2 > /sys/class/net/bond1/bonding/slaves
-	echo +eth3 > /sys/class/net/bond1/bonding/slaves
+	echo +eth2 > /sys/class/net/bond1/bonding/ports
+	echo +eth3 > /sys/class/net/bond1/bonding/ports
 
 3.5 Configuration with Interfaces Support
 -----------------------------------------
@@ -1589,7 +1589,7 @@ Example Configurations
 ----------------------
 
 In /etc/network/interfaces, the following stanza will configure bond0, in
-active-backup mode, with eth0 and eth1 as slaves::
+active-backup mode, with eth0 and eth1 as ports::
 
 	auto bond0
 	iface bond0 inet dhcp
@@ -1645,7 +1645,7 @@ tx_queues can be used to change this value.  There is no sysfs parameter
 available as the allocation is done at module init time.
 
 The output of the file /proc/net/bonding/bondX has changed so the output Queue
-ID is now printed for each slave::
+ID is now printed for each slave port::
 
 	Bonding Mode: fault-tolerance (active-backup)
 	Primary Slave: None
@@ -1667,18 +1667,18 @@ ID is now printed for each slave::
 	Permanent HW addr: 00:1a:a0:12:8f:cc
 	Slave queue ID: 2
 
-The queue_id for a slave can be set using the command::
+The queue_id for a port can be set using the command::
 
 	# echo "eth1:2" > /sys/class/net/bond0/bonding/queue_id
 
 Any interface that needs a queue_id set should set it with multiple calls
 like the one above until proper priorities are set for all interfaces.  On
 distributions that allow configuration via initscripts, multiple 'queue_id'
-arguments can be added to BONDING_OPTS to set all needed slave queues.
+arguments can be added to BONDING_OPTS to set all needed port queues.
 
 These queue id's can be used in conjunction with the tc utility to configure
 a multiqueue qdisc and filters to bias certain traffic to transmit on certain
-slave devices.  For instance, say we wanted, in the above configuration to
+port devices.  For instance, say we wanted, in the above configuration to
 force all traffic bound to 192.168.1.100 to use eth1 in the bond as its output
 device. The following commands would accomplish this::
 
@@ -1695,14 +1695,14 @@ selection policy to be overridden, selecting instead qid 2, which maps to eth1.
 
 Note that qid values begin at 1.  Qid 0 is reserved to initiate to the driver
 that normal output policy selection should take place.  One benefit to simply
-leaving the qid for a slave to 0 is the multiqueue awareness in the bonding
+leaving the qid for a port to 0 is the multiqueue awareness in the bonding
 driver that is now present.  This awareness allows tc filters to be placed on
-slave devices as well as bond devices and the bonding driver will simply act as
-a pass-through for selecting output queues on the slave device rather than
+port devices as well as bond devices and the bonding driver will simply act as
+a pass-through for selecting output queues on the port device rather than
 output port selection.
 
 This feature first appeared in bonding driver version 3.7.0 and support for
-output slave selection was limited to round-robin and active-backup modes.
+output port selection was limited to round-robin and active-backup modes.
 
 3.7 Configuring LACP for 802.3ad mode in a more secure way
 ----------------------------------------------------------
@@ -1759,7 +1759,7 @@ few bonding parameters:
 
 Each bonding device has a read-only file residing in the
 /proc/net/bonding directory.  The file contents include information
-about the bonding configuration, options and state of each slave.
+about the bonding configuration, options and state of each port.
 
 For example, the contents of /proc/net/bonding/bond0 after the
 driver is loaded with parameters of mode=0 and miimon=1000 is
@@ -1788,14 +1788,14 @@ bonding configuration, state, and version of the bonding driver.
 -------------------------
 
 The network configuration can be inspected using the ifconfig
-command.  Bonding devices will have the MASTER flag set; Bonding slave
+command.  Bonding devices will have the MASTER flag set; Bonding port
 devices will have the SLAVE flag set.  The ifconfig output does not
-contain information on which slaves are associated with which masters.
+contain information on which ports are associated with which bonds.
 
-In the example below, the bond0 interface is the master
-(MASTER) while eth0 and eth1 are slaves (SLAVE). Notice all slaves of
+In the example below, the bond0 interface is the bond device
+(MASTER) while eth0 and eth1 are ports (SLAVE). Notice all ports of
 bond0 have the same MAC address (HWaddr) as bond0 for all modes except
-TLB and ALB that require a unique MAC address for each slave::
+TLB and ALB that require a unique MAC address for each port::
 
   # /sbin/ifconfig
   bond0     Link encap:Ethernet  HWaddr 00:C0:F0:1F:37:B4
@@ -1868,29 +1868,29 @@ For reasons of simplicity, and to support the use of adapters
 that can do VLAN hardware acceleration offloading, the bonding
 interface declares itself as fully hardware offloading capable, it gets
 the add_vid/kill_vid notifications to gather the necessary
-information, and it propagates those actions to the slaves.  In case
+information, and it propagates those actions to the ports.  In case
 of mixed adapter types, hardware accelerated tagged packets that
 should go through an adapter that is not offloading capable are
 "un-accelerated" by the bonding driver so the VLAN tag sits in the
 regular location.
 
 VLAN interfaces *must* be added on top of a bonding interface
-only after enslaving at least one slave.  The bonding interface has a
-hardware address of 00:00:00:00:00:00 until the first slave is added.
-If the VLAN interface is created prior to the first enslavement, it
-would pick up the all-zeroes hardware address.  Once the first slave
+only after enslaving at least one port.  The bonding interface has a
+hardware address of 00:00:00:00:00:00 until the first port is added.
+If the VLAN interface is created prior to the first port binding, it
+would pick up the all-zeroes hardware address.  Once the first port
 is attached to the bond, the bond device itself will pick up the
-slave's hardware address, which is then available for the VLAN device.
+port's hardware address, which is then available for the VLAN device.
 
-Also, be aware that a similar problem can occur if all slaves
+Also, be aware that a similar problem can occur if all ports
 are released from a bond that still has one or more VLAN interfaces on
-top of it.  When a new slave is added, the bonding interface will
-obtain its hardware address from the first slave, which might not
+top of it.  When a new port is added, the bonding interface will
+obtain its hardware address from the first port, which might not
 match the hardware address of the VLAN interfaces (which was
-ultimately copied from an earlier slave).
+ultimately copied from an earlier port).
 
 There are two methods to insure that the VLAN device operates
-with the correct hardware address if all slaves are removed from a
+with the correct hardware address if all ports are removed from a
 bond interface:
 
 1. Remove all VLAN interfaces then recreate them
@@ -1907,7 +1907,7 @@ mode, which might not be what you want.
 ==================
 
 The bonding driver at present supports two schemes for
-monitoring a slave device's link state: the ARP monitor and the MII
+monitoring a port device's link state: the ARP monitor and the MII
 monitor.
 
 At the present time, due to implementation restrictions in the
@@ -1927,8 +1927,8 @@ The ARP monitor relies on the device driver itself to verify
 that traffic is flowing.  In particular, the driver must keep up to
 date the last receive time, dev->last_rx.  Drivers that use NETIF_F_LLTX
 flag must also update netdev_queue->trans_start.  If they do not, then the
-ARP monitor will immediately fail any slaves using that driver, and
-those slaves will stay down.  If networking monitoring (tcpdump, etc)
+ARP monitor will immediately fail any ports using that driver, and
+those ports will stay down.  If networking monitoring (tcpdump, etc)
 shows the ARP requests and replies on the network, then it may be that
 your device driver is not updating last_rx and trans_start.
 
@@ -1987,10 +1987,10 @@ up.
 8.1 Adventures in Routing
 -------------------------
 
-When bonding is configured, it is important that the slave
-devices not have routes that supersede routes of the master (or,
+When bonding is configured, it is important that the port
+devices not have routes that supersede routes of the bond (or,
 generally, not have routes at all).  For example, suppose the bonding
-device bond0 has two slaves, eth0 and eth1, and the routing table is
+device bond0 has two ports, eth0 and eth1, and the routing table is
 as follows::
 
   Kernel IP routing table
@@ -2013,9 +2013,9 @@ as an unsolicited ARP reply (because ARP matches replies on an
 interface basis), and is discarded.  The MII monitor is not affected
 by the state of the routing table.
 
-The solution here is simply to insure that slaves do not have
+The solution here is simply to insure that ports do not have
 routes of their own, and if for some reason they must, those routes do
-not supersede routes of their master.  This should generally be the
+not supersede routes of their bond.  This should generally be the
 case, but unusual configurations or errant manual or automatic static
 route additions may cause trouble.
 
@@ -2037,12 +2037,12 @@ For example, given a modules.conf containing the following::
 	alias eth2 e1000
 	alias eth3 e1000
 
-If neither eth0 and eth1 are slaves to bond0, then when the
+If neither eth0 and eth1 are ports to bond0, then when the
 bond0 interface comes up, the devices may end up reordered.  This
-happens because bonding is loaded first, then its slave device's
+happens because bonding is loaded first, then its port device's
 drivers are loaded next.  Since no other drivers have been loaded,
 when the e1000 driver loads, it will receive eth0 and eth1 for its
-devices, but the bonding configuration tries to enslave eth2 and eth3
+devices, but the bonding configuration tries to connect eth2 and eth3
 (which may later be assigned to the tg3 devices).
 
 Adding the following::
@@ -2099,7 +2099,7 @@ before any network drivers participating in a bond.  This requirement
 is due to the interface index (ipAdEntIfIndex) being associated to
 the first interface found with a given IP address.  That is, there is
 only one ipAdEntIfIndex for each IP address.  For example, if eth0 and
-eth1 are slaves of bond0 and the driver for eth0 is loaded before the
+eth1 are ports of bond0 and the driver for eth0 is loaded before the
 bonding driver, the interface for the IP address will be associated
 with the eth0 interface.  This configuration is shown below, the IP
 address 192.168.1.1 has an interface index of 2 which indexes to eth0
@@ -2146,25 +2146,25 @@ When running network monitoring tools, e.g., tcpdump, it is
 common to enable promiscuous mode on the device, so that all traffic
 is seen (instead of seeing only traffic destined for the local host).
 The bonding driver handles promiscuous mode changes to the bonding
-master device (e.g., bond0), and propagates the setting to the slave
+bond device (e.g., bond0), and propagates the setting to the port
 devices.
 
 For the balance-rr, balance-xor, broadcast, and 802.3ad modes,
-the promiscuous mode setting is propagated to all slaves.
+the promiscuous mode setting is propagated to all ports.
 
 For the active-backup, balance-tlb and balance-alb modes, the
-promiscuous mode setting is propagated only to the active slave.
+promiscuous mode setting is propagated only to the active port.
 
-For balance-tlb mode, the active slave is the slave currently
+For balance-tlb mode, the active port is the port currently
 receiving inbound traffic.
 
-For balance-alb mode, the active slave is the slave used as a
-"primary."  This slave is used for mode-specific control traffic, for
+For balance-alb mode, the active port is the port used as a
+"primary."  This port is used for mode-specific control traffic, for
 sending to peers that are unassigned or if the load is unbalanced.
 
 For the active-backup, balance-tlb and balance-alb modes, when
-the active slave changes (e.g., due to a link failure), the
-promiscuous setting will be propagated to the new active slave.
+the active port changes (e.g., due to a link failure), the
+promiscuous setting will be propagated to the new active port.
 
 11. Configuring Bonding for High Availability
 =============================================
@@ -2464,7 +2464,7 @@ balance-tlb:
 	special switch configuration is required.  On the down side,
 	in this mode all incoming traffic arrives over a single
 	interface, this mode requires certain ethtool support in the
-	network device driver of the slave interfaces, and the ARP
+	network device driver of the port interfaces, and the ARP
 	monitor is not available.
 
 balance-alb:
@@ -2571,7 +2571,7 @@ help.
 Note that when a bonding interface has no active links, the
 driver will immediately reuse the first link that goes up, even if the
 updelay parameter has been specified (the updelay is ignored in this
-case).  If there are slave interfaces waiting for the updelay timeout
+case).  If there are port interfaces waiting for the updelay timeout
 to expire, the interface that first went into that state will be
 immediately reused.  This reduces down time of the network if the
 value of updelay has been overestimated, and since this occurs only in
@@ -2594,9 +2594,9 @@ It is not uncommon to observe a short burst of duplicated
 traffic when the bonding device is first used, or after it has been
 idle for some period of time.  This is most easily observed by issuing
 a "ping" to some other host on the network, and noticing that the
-output from ping flags duplicates (typically one per slave).
+output from ping flags duplicates (typically one per port).
 
-For example, on a bond in active-backup mode with five slaves
+For example, on a bond in active-backup mode with five ports
 all connected to one switch, the output may appear as follows::
 
 	# ping -n 10.0.4.2
@@ -2618,7 +2618,7 @@ traffic to all ports until its MAC forwarding table is updated.  Since
 the interfaces attached to the bond may occupy multiple ports on a
 single switch, when the switch (temporarily) floods the traffic to all
 ports, the bond device receives multiple copies of the same packet
-(one per slave device).
+(one per port device).
 
 The duplicated packet behavior is switch dependent, some
 switches exhibit this, and some do not.  On switches that display this
@@ -2753,21 +2753,21 @@ EtherExpress PRO/100 and a 3com 3c905b, for example).  For most modes,
 devices need not be of the same speed.
 
 Starting with version 3.2.1, bonding also supports Infiniband
-slaves in active-backup mode.
+ports in active-backup mode.
 
 3.  How many bonding devices can I have?
 ----------------------------------------
 
 There is no limit.
 
-4.  How many slaves can a bonding device have?
+4.  How many ports can a bonding device have?
 ----------------------------------------------
 
 This is limited only by the number of network interfaces Linux
 supports and/or the number of network cards you can place in your
 system.
 
-5.  What happens when a slave link dies?
+5.  What happens when a port link dies?
 ----------------------------------------
 
 If link monitoring is enabled, then the failing device will be
@@ -2819,14 +2819,14 @@ The active-backup mode should work with any Layer-II switch.
 8.  Where does a bonding device get its MAC address from?
 ---------------------------------------------------------
 
-When using slave devices that have fixed MAC addresses, or when
+When using port devices that have fixed MAC addresses, or when
 the fail_over_mac option is enabled, the bonding device's MAC address is
-the MAC address of the active slave.
+the MAC address of the active port.
 
 For other configurations, if not explicitly configured (with
 ifconfig or ip link), the MAC address of the bonding device is taken from
-its first slave device.  This MAC address is then passed to all following
-slaves and remains persistent (even if the first slave is removed) until
+its first port device.  This MAC address is then passed to all following
+ports and remains persistent (even if the first port is removed) until
 the bonding device is brought down or reconfigured.
 
 If you wish to change the MAC address, you can set it with
@@ -2837,19 +2837,19 @@ ifconfig or ip link::
 	# ip link set bond0 address 66:77:88:99:aa:bb
 
 The MAC address can be also changed by bringing down/up the
-device and then changing its slaves (or their order)::
+device and then changing its ports (or their order)::
 
 	# ifconfig bond0 down ; modprobe -r bonding
 	# ifconfig bond0 .... up
 	# ifenslave bond0 eth...
 
 This method will automatically take the address from the next
-slave that is added.
+port that is added.
 
-To restore your slaves' MAC addresses, you need to detach them
+To restore your ports' MAC addresses, you need to detach them
 from the bond (``ifenslave -d bond0 eth0``). The bonding driver will
-then restore the MAC addresses that the slaves had before they were
-enslaved.
+then restore the MAC addresses that the ports had before they were
+connected.
 
 16. Resources and Links
 =======================
-- 
2.27.0

