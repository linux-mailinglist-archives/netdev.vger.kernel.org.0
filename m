Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B08D182615
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 01:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731476AbgCLABg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 20:01:36 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45880 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbgCLABg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 20:01:36 -0400
Received: by mail-qk1-f196.google.com with SMTP id c145so3955144qke.12
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 17:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y1DJukymEe1shknFrWhg7PDjgAA7pPjt2c/mgWCt3MM=;
        b=q5tGcXvAwJMcZmz4tUgQnrI/JjRKVonPuO165vbWqtHIbbgfLDP3Ne+ASPQhUsLafR
         0lE+LjeHvIi7l8/Ka7OtlpHeoRrVY3sVRBq0Fs+R6Sqv1zcRdQ3pORs39cZurARvOPSE
         ijSMHJWXcblukXkiR7Ot/reOqktn3taX+dP9+y+ME+5yabhCWfKaiQ0S1jaNocux+pix
         YcwtdB36Vk6kY2fJXpgo4toBCria0Nz3R5sNb0oZdfre1CN/Pe+gsJlwnHw0/LesARfv
         Ujs28IpxGQEqO2jPcCDgcdEqmqqD0LB7cnrodKnL3Vco1WPRXFYqMR4qMBvUE4b5w67s
         A6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y1DJukymEe1shknFrWhg7PDjgAA7pPjt2c/mgWCt3MM=;
        b=Q7vzoNzvqhMge88ix4tHy/rrb14uzZaeHdDEaIMzoTqIpbxsyaR9kVWwoGwVi5cg5s
         ioqUc9+RLQv8EftU3L5Sap6HvFSqWrDGPTMcMBDK3/i07MGGavL36/hmy7QVU1I0ikEg
         alpPmIdOwKsmHP8sEIZAZQxHod/+zbLXAhbcwUtefY2U2BWtMPRLjCcQa9m1WJ3lyUmD
         ahlBPqAYCCLLlod+WpYJ/SCjTGIPYNYIjPXU0+Gy3QFrUETWQNDrWCmJ07+uvhaNBVNx
         3A4VxmQrFAFlFeh8oFNyVQID5loWXFjj7MBY71B5kNV2800bYG/VmU31F/y6lsnB2zIs
         HX3w==
X-Gm-Message-State: ANhLgQ364889SpYnVvorGvol68NnnxzbtI5ADkzomxlAT+A1GU0E9kuQ
        RhdFgyT0sAUuyYd4BVPt6Mg=
X-Google-Smtp-Source: ADFU+vuVqR5DKWQ3KiYCxSV0HMWKx4Fra+kZYePAPwfyl/nSvEo/a72S/4A97NnJWl/qAy0ChqAgkw==
X-Received: by 2002:a37:a154:: with SMTP id k81mr5103939qke.496.1583971290894;
        Wed, 11 Mar 2020 17:01:30 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.211])
        by smtp.gmail.com with ESMTPSA id n46sm11099436qtb.48.2020.03.11.17.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 17:01:30 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CD475C58F6; Wed, 11 Mar 2020 21:01:26 -0300 (-03)
Date:   Wed, 11 Mar 2020 21:01:26 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next ct-offload v3 00/15] Introduce connection
 tracking offload
Message-ID: <20200312000126.GF2547@localhost.localdomain>
References: <1583937238-21511-1-git-send-email-paulb@mellanox.com>
 <20200311191353.GL2546@localhost.localdomain>
 <511542c9-2028-a5a8-4e4a-367b916a7f1c@mellanox.com>
 <20200311224415.GL3614@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311224415.GL3614@localhost.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 07:44:15PM -0300, Marcelo Ricardo Leitner wrote:
> On Thu, Mar 12, 2020 at 12:27:37AM +0200, Paul Blakey wrote:
...
> > if not try skipping flow_action_hw_stats_types_check() calls in mlx5 driver.
> 
> Ok. This one was my main suspect now after some extra printks. I could
> confirm it parse_tc_fdb_actions is returning the error, but not sure
> why yet.

Copied the extack in flow_action_mixed_hw_stats_types_check() onto a
printk and logged the if parameters:

@@ -284,6 +284,8 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,

        flow_action_for_each(i, action_entry, action) {
                if (i && action_entry->hw_stats_type != last_hw_stats_type) {
+                       printk("Mixing HW stats types for actions is not supported, %d %d %d\n",
+                              i, action_entry->hw_stats_type, last_hw_stats_type);
                        NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");

[  188.554636] Mixing HW stats types for actions is not supported, 2 0 3

with iproute-next from today loaded with
'iproute2/net-next v2] tc: m_action: introduce support for hw stats
type', I get a dump like:

# ./tc -s filter show dev vxlan_sys_4789 ingress
filter protocol ip pref 2 flower chain 0
filter protocol ip pref 2 flower chain 0 handle 0x1
  dst_mac 6a:66:2d:48:92:c2
  src_mac 00:00:00:00:0e:b7
  eth_type ipv4
  ip_proto udp
  ip_ttl 64
  src_port 100
  enc_dst_ip 1.1.1.1
  enc_src_ip 1.1.1.2
  enc_key_id 0
  enc_dst_port 4789
  enc_tos 0
  ip_flags nofrag
  not_in_hw
        action order 1: tunnel_key  unset pipe
         index 4 ref 1 bind 1 installed 2432 sec used 0 sec
        Action statistics:
        Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        no_percpu

        action order 2:  pedit action pipe keys 2
         index 4 ref 1 bind 1 installed 2432 sec used 0 sec
         key #0  at ipv4+8: val 3f000000 mask 00ffffff
         key #1  at udp+0: val 13890000 mask 0000ffff
        Action statistics:
        Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

        action order 3: csum (iph, udp) action pipe
        index 4 ref 1 bind 1 installed 2432 sec used 0 sec
        Action statistics:
        Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        no_percpu

        action order 4: mirred (Egress Redirect to device eth0) stolen
        index 1 ref 1 bind 1 installed 2432 sec used 0 sec
        Action statistics:
        Sent 223744 bytes 4864 pkt (dropped 0, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0
        cookie 9c7d6b3aa84a32498181d98da0af80d2
        no_percpu

Which is quite interesting as it is not listing any hwstats fields at all.
Considering that due to tcf_action_hw_stats_type_get() and
hw_stats_type initialization in tcf_action_init_1(), the default is
for it to be 3 if not specified (which is then not dumped over netlink
by the kernel).

I'm wondering how it was 0 for i==0,1 and is 3 for i==2.

