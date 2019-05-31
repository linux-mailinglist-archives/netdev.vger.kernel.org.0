Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB73161A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfEaUWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:22:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:43350 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727531AbfEaUWu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:22:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 13:22:48 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 31 May 2019 13:22:46 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWo33-000GcR-W8; Sat, 01 Jun 2019 04:22:45 +0800
Date:   Sat, 1 Jun 2019 04:22:22 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V5 net-next 6/6] ptp: Add a driver for InES time stamping
 IP core.
Message-ID: <201906010459.0JWfjNIj%lkp@intel.com>
References: <297281011d671dafdced87755fd6e2bd41c6d141.1559281985.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <297281011d671dafdced87755fd6e2bd41c6d141.1559281985.git.richardcochran@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Richard-Cochran/Peer-to-Peer-One-Step-time-stamping/20190531-200348
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/ptp/ptp_ines.c:490:13: sparse: sparse: restricted __be64 degrades to integer
>> drivers/ptp/ptp_ines.c:495:28: sparse: sparse: cast to restricted __be16
>> drivers/ptp/ptp_ines.c:495:28: sparse: sparse: cast to restricted __be16
>> drivers/ptp/ptp_ines.c:495:28: sparse: sparse: cast to restricted __be16
>> drivers/ptp/ptp_ines.c:495:28: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:496:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:496:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:496:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:496:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:500:26: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:500:26: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:500:26: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:500:26: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:501:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:501:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:501:17: sparse: sparse: cast to restricted __be16
   drivers/ptp/ptp_ines.c:501:17: sparse: sparse: cast to restricted __be16
>> drivers/ptp/ptp_ines.c:543:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
>> drivers/ptp/ptp_ines.c:543:28: sparse:    expected void const volatile [noderef] <asn:2> *addr
>> drivers/ptp/ptp_ines.c:543:28: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:547:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:547:30: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:547:30: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:557:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:557:31: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:557:31: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:561:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:561:31: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:561:31: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:562:31: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:562:31: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:562:31: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:579:16: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:579:16: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:579:16: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:583:24: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:583:24: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:583:24: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:626:16: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:626:16: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:626:16: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:630:24: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:630:24: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:630:24: sparse:    got unsigned int *
>> drivers/ptp/ptp_ines.c:208:21: sparse: sparse: incorrect type in assignment (different address spaces) @@    expected struct ines_global_registers *regs @@    got  ines_global_registers *regs @@
>> drivers/ptp/ptp_ines.c:208:21: sparse:    expected struct ines_global_registers *regs
>> drivers/ptp/ptp_ines.c:208:21: sparse:    got void [noderef] <asn:2> *base
>> drivers/ptp/ptp_ines.c:225:9: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
>> drivers/ptp/ptp_ines.c:225:9: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:225:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:226:9: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:226:9: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:226:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:228:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:228:9: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:228:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:229:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:229:9: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:229:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:230:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:230:9: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:230:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:231:9: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:231:9: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:231:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:235:17: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:235:17: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:235:17: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:313:28: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:313:28: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:313:28: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:318:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:318:30: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:318:30: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:326:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:326:30: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:326:30: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:330:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:330:30: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:330:30: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:331:30: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:331:30: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:331:30: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:401:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:401:21: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:401:21: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:405:9: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:405:9: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:405:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:406:9: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:406:9: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:406:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:407:9: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:407:9: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:407:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:440:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:440:21: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:440:21: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:444:9: sparse: sparse: incorrect type in argument 2 (different address spaces) @@    expected void volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:444:9: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:444:9: sparse:    got unsigned int *
   drivers/ptp/ptp_ines.c:643:21: sparse: sparse: incorrect type in argument 1 (different address spaces) @@    expected void const volatile [noderef] <asn:2> *addr @@    got ref] <asn:2> *addr @@
   drivers/ptp/ptp_ines.c:643:21: sparse:    expected void const volatile [noderef] <asn:2> *addr
   drivers/ptp/ptp_ines.c:643:21: sparse:    got unsigned int *
>> drivers/ptp/ptp_ines.c:756:24: sparse: sparse: symbol 'ines_ptp_probe_channel' was not declared. Should it be static?
>> drivers/ptp/ptp_ines.c:785:30: sparse: sparse: symbol 'ines_ctrl' was not declared. Should it be static?

Please review and possibly fold the followup patch.

vim +490 drivers/ptp/ptp_ines.c

   416	
   417	static void ines_link_state(struct mii_timestamper *mii_ts,
   418				    struct phy_device *phydev)
   419	{
   420		struct ines_port *port = container_of(mii_ts, struct ines_port, mii_ts);
   421		u32 port_conf, speed_conf;
   422		unsigned long flags;
   423	
   424		switch (phydev->speed) {
   425		case SPEED_10:
   426			speed_conf = PHY_SPEED_10 << PHY_SPEED_SHIFT;
   427			break;
   428		case SPEED_100:
   429			speed_conf = PHY_SPEED_100 << PHY_SPEED_SHIFT;
   430			break;
   431		case SPEED_1000:
   432			speed_conf = PHY_SPEED_1000 << PHY_SPEED_SHIFT;
   433			break;
   434		default:
   435			pr_err("bad speed: %d\n", phydev->speed);
   436			return;
   437		}
   438		spin_lock_irqsave(&port->lock, flags);
   439	
 > 440		port_conf = ines_read32(port, port_conf);
   441		port_conf &= ~(0x3 << PHY_SPEED_SHIFT);
   442		port_conf |= speed_conf;
   443	
   444		ines_write32(port, port_conf, port_conf);
   445	
   446		spin_unlock_irqrestore(&port->lock, flags);
   447	}
   448	
   449	static bool ines_match(struct sk_buff *skb, unsigned int ptp_class,
   450			       struct ines_timestamp *ts)
   451	{
   452		u8 *msgtype, *data = skb_mac_header(skb);
   453		unsigned int offset = 0;
   454		u16 *portn, *seqid;
   455		u64 *clkid;
   456	
   457		if (unlikely(ptp_class & PTP_CLASS_V1))
   458			return false;
   459	
   460		if (ptp_class & PTP_CLASS_VLAN)
   461			offset += VLAN_HLEN;
   462	
   463		switch (ptp_class & PTP_CLASS_PMASK) {
   464		case PTP_CLASS_IPV4:
   465			offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
   466			break;
   467		case PTP_CLASS_IPV6:
   468			offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
   469			break;
   470		case PTP_CLASS_L2:
   471			offset += ETH_HLEN;
   472			break;
   473		default:
   474			return false;
   475		}
   476	
   477		if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
   478			return false;
   479	
   480		msgtype = data + offset;
   481		clkid = (u64 *)(data + offset + OFF_PTP_CLOCK_ID);
   482		portn = (u16 *)(data + offset + OFF_PTP_PORT_NUM);
   483		seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
   484	
   485		if (tag_to_msgtype(ts->tag & 0x7) != (*msgtype & 0xf)) {
   486			pr_debug("msgtype mismatch ts %hhu != skb %hhu\n",
   487				 tag_to_msgtype(ts->tag & 0x7), *msgtype & 0xf);
   488			return false;
   489		}
 > 490		if (cpu_to_be64(ts->clkid) != *clkid) {
   491			pr_debug("clkid mismatch ts %llx != skb %llx\n",
   492				 cpu_to_be64(ts->clkid), *clkid);
   493			return false;
   494		}
 > 495		if (ts->portnum != ntohs(*portn)) {
 > 496			pr_debug("portn mismatch ts %hu != skb %hu\n",
   497				 ts->portnum, ntohs(*portn));
   498			return false;
   499		}
 > 500		if (ts->seqid != ntohs(*seqid)) {
   501			pr_debug("seqid mismatch ts %hu != skb %hu\n",
   502				 ts->seqid, ntohs(*seqid));
   503			return false;
   504		}
   505	
   506		return true;
   507	}
   508	
   509	static bool ines_rxtstamp(struct mii_timestamper *mii_ts,
   510				  struct sk_buff *skb, int type)
   511	{
   512		struct ines_port *port = container_of(mii_ts, struct ines_port, mii_ts);
   513		struct skb_shared_hwtstamps *ssh;
   514		u64 ns;
   515	
   516		if (!port->rxts_enabled)
   517			return false;
   518	
   519		ns = ines_find_rxts(port, skb, type);
   520		if (!ns)
   521			return false;
   522	
   523		ssh = skb_hwtstamps(skb);
   524		ssh->hwtstamp = ns_to_ktime(ns);
   525		netif_rx(skb);
   526	
   527		return true;
   528	}
   529	
   530	static int ines_rxfifo_read(struct ines_port *port)
   531	{
   532		u32 data_rd_pos, buf_stat, mask, ts_stat_rx;
   533		struct ines_timestamp *ts;
   534		unsigned int i;
   535	
   536		mask = RX_FIFO_NE_1 << port->index;
   537	
   538		for (i = 0; i < INES_FIFO_DEPTH; i++) {
   539			if (list_empty(&port->pool)) {
   540				pr_err("event pool is empty\n");
   541				return -1;
   542			}
 > 543			buf_stat = ines_read32(port->clock, buf_stat);
   544			if (!(buf_stat & mask))
   545				break;
   546	
   547			ts_stat_rx = ines_read32(port, ts_stat_rx);
   548			data_rd_pos = (ts_stat_rx >> DATA_READ_POS_SHIFT) &
   549				DATA_READ_POS_MASK;
   550			if (data_rd_pos) {
   551				pr_err("unexpected Rx read pos %u\n", data_rd_pos);
   552				break;
   553			}
   554	
   555			ts = list_first_entry(&port->pool, struct ines_timestamp, list);
   556			ts->tmo     = jiffies + HZ;
   557			ts->tag     = ines_read32(port, ts_rx);
   558			ts->sec     = ines_rxts64(port, 3);
   559			ts->nsec    = ines_rxts64(port, 2);
   560			ts->clkid   = ines_rxts64(port, 4);
   561			ts->portnum = ines_read32(port, ts_rx);
   562			ts->seqid   = ines_read32(port, ts_rx);
   563	
   564			ines_dump_ts("Rx", ts);
   565	
   566			list_del_init(&ts->list);
   567			list_add_tail(&ts->list, &port->events);
   568		}
   569	
   570		return 0;
   571	}
   572	
   573	static u64 ines_rxts64(struct ines_port *port, unsigned int words)
   574	{
   575		unsigned int i;
   576		u64 result;
   577		u16 word;
   578	
   579		word = ines_read32(port, ts_rx);
   580		result = word;
   581		words--;
   582		for (i = 0; i < words; i++) {
 > 583			word = ines_read32(port, ts_rx);
   584			result <<= 16;
   585			result |= word;
   586		}
   587		return result;
   588	}
   589	
   590	static bool ines_timestamp_expired(struct ines_timestamp *ts)
   591	{
   592		return time_after(jiffies, ts->tmo);
   593	}
   594	
   595	static int ines_ts_info(struct mii_timestamper *mii_ts,
   596				struct ethtool_ts_info *info)
   597	{
   598		info->so_timestamping =
   599			SOF_TIMESTAMPING_TX_HARDWARE |
   600			SOF_TIMESTAMPING_TX_SOFTWARE |
   601			SOF_TIMESTAMPING_RX_HARDWARE |
   602			SOF_TIMESTAMPING_RX_SOFTWARE |
   603			SOF_TIMESTAMPING_SOFTWARE |
   604			SOF_TIMESTAMPING_RAW_HARDWARE;
   605	
   606		info->phc_index = -1;
   607	
   608		info->tx_types =
   609			(1 << HWTSTAMP_TX_OFF) |
   610			(1 << HWTSTAMP_TX_ON) |
   611			(1 << HWTSTAMP_TX_ONESTEP_P2P);
   612	
   613		info->rx_filters =
   614			(1 << HWTSTAMP_FILTER_NONE) |
   615			(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
   616	
   617		return 0;
   618	}
   619	
   620	static u64 ines_txts64(struct ines_port *port, unsigned int words)
   621	{
   622		unsigned int i;
   623		u64 result;
   624		u16 word;
   625	
 > 626		word = ines_read32(port, ts_tx);
   627		result = word;
   628		words--;
   629		for (i = 0; i < words; i++) {
   630			word = ines_read32(port, ts_tx);
   631			result <<= 16;
   632			result |= word;
   633		}
   634		return result;
   635	}
   636	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
