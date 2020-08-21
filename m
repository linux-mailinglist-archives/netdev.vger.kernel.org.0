Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E15124D543
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 14:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgHUMo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 08:44:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:10227 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728516AbgHUMoZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 08:44:25 -0400
IronPort-SDR: N8UqnGMQBdQBN6QlY0xFB+EICzKeYcy/7o0effkPfJ6X/XH5lbDN9aE3zgdWKCRpyHRDwq3EBu
 5V3Ki8Afd+eA==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="135580437"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="gz'50?scan'50,208,50";a="135580437"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 05:29:17 -0700
IronPort-SDR: Hn9BB/wsjcmM1z/leJ4zzaLlgbw7CvBJUfe7VRTh2gIlw0eTXSxo/gGpz1SleDA4yTZ8HcCOEi
 g7gtNIEry6GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="gz'50?scan'50,208,50";a="401457488"
Received: from lkp-server01.sh.intel.com (HELO 91ed66e1ca04) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 21 Aug 2020 05:29:15 -0700
Received: from kbuild by 91ed66e1ca04 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1k96AU-00011O-Kg; Fri, 21 Aug 2020 12:29:14 +0000
Date:   Fri, 21 Aug 2020 20:28:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, jchapman@katalix.com,
        Tom Parkin <tparkin@katalix.com>
Subject: Re: [PATCH 1/9] l2tp: don't log data frames
Message-ID: <202008212019.nMaa8rae%lkp@intel.com>
References: <20200821104728.23530-2-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200821104728.23530-2-tparkin@katalix.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Tom,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tom-Parkin/l2tp-replace-custom-logging-code-with-tracepoints/20200821-184919
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git d0a84e1f38d9d6ae2dfab0b6c2407d667a265aa5
config: riscv-randconfig-r035-20200820 (attached as .config)
compiler: riscv32-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=riscv 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/l2tp/l2tp_core.c: In function 'l2tp_recv_common':
>> net/l2tp/l2tp_core.c:663:14: warning: variable 'nr' set but not used [-Wunused-but-set-variable]
     663 |  u32 ns = 0, nr = 0;
         |              ^~

# https://github.com/0day-ci/linux/commit/5b9d9c3057638c81876e600aa2210e4a3e35fa8d
git remote add linux-review https://github.com/0day-ci/linux
git fetch --no-tags linux-review Tom-Parkin/l2tp-replace-custom-logging-code-with-tracepoints/20200821-184919
git checkout 5b9d9c3057638c81876e600aa2210e4a3e35fa8d
vim +/nr +663 net/l2tp/l2tp_core.c

b6dc01a43aaca24 James Chapman          2013-07-02  598  
f7faffa3ff8ef6a James Chapman          2010-04-02  599  /* Do receive processing of L2TP data frames. We handle both L2TPv2
f7faffa3ff8ef6a James Chapman          2010-04-02  600   * and L2TPv3 data frames here.
f7faffa3ff8ef6a James Chapman          2010-04-02  601   *
f7faffa3ff8ef6a James Chapman          2010-04-02  602   * L2TPv2 Data Message Header
f7faffa3ff8ef6a James Chapman          2010-04-02  603   *
f7faffa3ff8ef6a James Chapman          2010-04-02  604   *  0                   1                   2                   3
f7faffa3ff8ef6a James Chapman          2010-04-02  605   *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
f7faffa3ff8ef6a James Chapman          2010-04-02  606   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  607   * |T|L|x|x|S|x|O|P|x|x|x|x|  Ver  |          Length (opt)         |
f7faffa3ff8ef6a James Chapman          2010-04-02  608   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  609   * |           Tunnel ID           |           Session ID          |
f7faffa3ff8ef6a James Chapman          2010-04-02  610   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  611   * |             Ns (opt)          |             Nr (opt)          |
f7faffa3ff8ef6a James Chapman          2010-04-02  612   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  613   * |      Offset Size (opt)        |    Offset pad... (opt)
f7faffa3ff8ef6a James Chapman          2010-04-02  614   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  615   *
f7faffa3ff8ef6a James Chapman          2010-04-02  616   * Data frames are marked by T=0. All other fields are the same as
f7faffa3ff8ef6a James Chapman          2010-04-02  617   * those in L2TP control frames.
f7faffa3ff8ef6a James Chapman          2010-04-02  618   *
f7faffa3ff8ef6a James Chapman          2010-04-02  619   * L2TPv3 Data Message Header
f7faffa3ff8ef6a James Chapman          2010-04-02  620   *
f7faffa3ff8ef6a James Chapman          2010-04-02  621   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  622   * |                      L2TP Session Header                      |
f7faffa3ff8ef6a James Chapman          2010-04-02  623   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  624   * |                      L2-Specific Sublayer                     |
f7faffa3ff8ef6a James Chapman          2010-04-02  625   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  626   * |                        Tunnel Payload                      ...
f7faffa3ff8ef6a James Chapman          2010-04-02  627   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  628   *
f7faffa3ff8ef6a James Chapman          2010-04-02  629   * L2TPv3 Session Header Over IP
f7faffa3ff8ef6a James Chapman          2010-04-02  630   *
f7faffa3ff8ef6a James Chapman          2010-04-02  631   *  0                   1                   2                   3
f7faffa3ff8ef6a James Chapman          2010-04-02  632   *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
f7faffa3ff8ef6a James Chapman          2010-04-02  633   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  634   * |                           Session ID                          |
f7faffa3ff8ef6a James Chapman          2010-04-02  635   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  636   * |               Cookie (optional, maximum 64 bits)...
f7faffa3ff8ef6a James Chapman          2010-04-02  637   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  638   *                                                                 |
f7faffa3ff8ef6a James Chapman          2010-04-02  639   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  640   *
f7faffa3ff8ef6a James Chapman          2010-04-02  641   * L2TPv3 L2-Specific Sublayer Format
f7faffa3ff8ef6a James Chapman          2010-04-02  642   *
f7faffa3ff8ef6a James Chapman          2010-04-02  643   *  0                   1                   2                   3
f7faffa3ff8ef6a James Chapman          2010-04-02  644   *  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
f7faffa3ff8ef6a James Chapman          2010-04-02  645   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  646   * |x|S|x|x|x|x|x|x|              Sequence Number                  |
f7faffa3ff8ef6a James Chapman          2010-04-02  647   * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
f7faffa3ff8ef6a James Chapman          2010-04-02  648   *
23fe846f9a48d53 Guillaume Nault        2018-01-05  649   * Cookie value and sublayer format are negotiated with the peer when
23fe846f9a48d53 Guillaume Nault        2018-01-05  650   * the session is set up. Unlike L2TPv2, we do not need to parse the
23fe846f9a48d53 Guillaume Nault        2018-01-05  651   * packet header to determine if optional fields are present.
f7faffa3ff8ef6a James Chapman          2010-04-02  652   *
f7faffa3ff8ef6a James Chapman          2010-04-02  653   * Caller must already have parsed the frame and determined that it is
f7faffa3ff8ef6a James Chapman          2010-04-02  654   * a data (not control) frame before coming here. Fields up to the
f7faffa3ff8ef6a James Chapman          2010-04-02  655   * session-id have already been parsed and ptr points to the data
f7faffa3ff8ef6a James Chapman          2010-04-02  656   * after the session-id.
fd558d186df2c13 James Chapman          2010-04-02  657   */
f7faffa3ff8ef6a James Chapman          2010-04-02  658  void l2tp_recv_common(struct l2tp_session *session, struct sk_buff *skb,
f7faffa3ff8ef6a James Chapman          2010-04-02  659  		      unsigned char *ptr, unsigned char *optr, u16 hdrflags,
2b139e6b1ec86e1 Guillaume Nault        2018-07-25  660  		      int length)
fd558d186df2c13 James Chapman          2010-04-02  661  {
f7faffa3ff8ef6a James Chapman          2010-04-02  662  	struct l2tp_tunnel *tunnel = session->tunnel;
95075150d0bdaa7 Tom Parkin             2020-07-24 @663  	u32 ns = 0, nr = 0;
fd558d186df2c13 James Chapman          2010-04-02  664  	int offset;
fd558d186df2c13 James Chapman          2010-04-02  665  
f7faffa3ff8ef6a James Chapman          2010-04-02  666  	/* Parse and check optional cookie */
f7faffa3ff8ef6a James Chapman          2010-04-02  667  	if (session->peer_cookie_len > 0) {
f7faffa3ff8ef6a James Chapman          2010-04-02  668  		if (memcmp(ptr, &session->peer_cookie[0], session->peer_cookie_len)) {
a4ca44fa578c7c7 Joe Perches            2012-05-16  669  			l2tp_info(tunnel, L2TP_MSG_DATA,
f7faffa3ff8ef6a James Chapman          2010-04-02  670  				  "%s: cookie mismatch (%u/%u). Discarding.\n",
a4ca44fa578c7c7 Joe Perches            2012-05-16  671  				  tunnel->name, tunnel->tunnel_id,
a4ca44fa578c7c7 Joe Perches            2012-05-16  672  				  session->session_id);
7b7c0719cd7afee Tom Parkin             2013-03-19  673  			atomic_long_inc(&session->stats.rx_cookie_discards);
f7faffa3ff8ef6a James Chapman          2010-04-02  674  			goto discard;
f7faffa3ff8ef6a James Chapman          2010-04-02  675  		}
f7faffa3ff8ef6a James Chapman          2010-04-02  676  		ptr += session->peer_cookie_len;
f7faffa3ff8ef6a James Chapman          2010-04-02  677  	}
f7faffa3ff8ef6a James Chapman          2010-04-02  678  
fd558d186df2c13 James Chapman          2010-04-02  679  	/* Handle the optional sequence numbers. Sequence numbers are
fd558d186df2c13 James Chapman          2010-04-02  680  	 * in different places for L2TPv2 and L2TPv3.
fd558d186df2c13 James Chapman          2010-04-02  681  	 *
fd558d186df2c13 James Chapman          2010-04-02  682  	 * If we are the LAC, enable/disable sequence numbers under
fd558d186df2c13 James Chapman          2010-04-02  683  	 * the control of the LNS.  If no sequence numbers present but
fd558d186df2c13 James Chapman          2010-04-02  684  	 * we were expecting them, discard frame.
fd558d186df2c13 James Chapman          2010-04-02  685  	 */
fd558d186df2c13 James Chapman          2010-04-02  686  	L2TP_SKB_CB(skb)->has_seq = 0;
f7faffa3ff8ef6a James Chapman          2010-04-02  687  	if (tunnel->version == L2TP_HDR_VER_2) {
fd558d186df2c13 James Chapman          2010-04-02  688  		if (hdrflags & L2TP_HDRFLAG_S) {
f7faffa3ff8ef6a James Chapman          2010-04-02  689  			ns = ntohs(*(__be16 *)ptr);
fd558d186df2c13 James Chapman          2010-04-02  690  			ptr += 2;
fd558d186df2c13 James Chapman          2010-04-02  691  			nr = ntohs(*(__be16 *)ptr);
fd558d186df2c13 James Chapman          2010-04-02  692  			ptr += 2;
fd558d186df2c13 James Chapman          2010-04-02  693  
fd558d186df2c13 James Chapman          2010-04-02  694  			/* Store L2TP info in the skb */
fd558d186df2c13 James Chapman          2010-04-02  695  			L2TP_SKB_CB(skb)->ns = ns;
fd558d186df2c13 James Chapman          2010-04-02  696  			L2TP_SKB_CB(skb)->has_seq = 1;
fd558d186df2c13 James Chapman          2010-04-02  697  		}
f7faffa3ff8ef6a James Chapman          2010-04-02  698  	} else if (session->l2specific_type == L2TP_L2SPECTYPE_DEFAULT) {
f7faffa3ff8ef6a James Chapman          2010-04-02  699  		u32 l2h = ntohl(*(__be32 *)ptr);
f7faffa3ff8ef6a James Chapman          2010-04-02  700  
f7faffa3ff8ef6a James Chapman          2010-04-02  701  		if (l2h & 0x40000000) {
f7faffa3ff8ef6a James Chapman          2010-04-02  702  			ns = l2h & 0x00ffffff;
f7faffa3ff8ef6a James Chapman          2010-04-02  703  
f7faffa3ff8ef6a James Chapman          2010-04-02  704  			/* Store L2TP info in the skb */
f7faffa3ff8ef6a James Chapman          2010-04-02  705  			L2TP_SKB_CB(skb)->ns = ns;
f7faffa3ff8ef6a James Chapman          2010-04-02  706  			L2TP_SKB_CB(skb)->has_seq = 1;
f7faffa3ff8ef6a James Chapman          2010-04-02  707  		}
62e7b6a57c7b9bf Lorenzo Bianconi       2018-01-16  708  		ptr += 4;
f7faffa3ff8ef6a James Chapman          2010-04-02  709  	}
f7faffa3ff8ef6a James Chapman          2010-04-02  710  
fd558d186df2c13 James Chapman          2010-04-02  711  	if (L2TP_SKB_CB(skb)->has_seq) {
20dcb1107ab1a34 Tom Parkin             2020-07-22  712  		/* Received a packet with sequence numbers. If we're the LAC,
fd558d186df2c13 James Chapman          2010-04-02  713  		 * check if we sre sending sequence numbers and if not,
fd558d186df2c13 James Chapman          2010-04-02  714  		 * configure it so.
fd558d186df2c13 James Chapman          2010-04-02  715  		 */
6c0ec37b8283463 Tom Parkin             2020-07-23  716  		if (!session->lns_mode && !session->send_seq) {
a4ca44fa578c7c7 Joe Perches            2012-05-16  717  			l2tp_info(session, L2TP_MSG_SEQ,
fd558d186df2c13 James Chapman          2010-04-02  718  				  "%s: requested to enable seq numbers by LNS\n",
fd558d186df2c13 James Chapman          2010-04-02  719  				  session->name);
3f9b9770b479986 Asbjørn Sloth Tønnesen 2016-11-07  720  			session->send_seq = 1;
f7faffa3ff8ef6a James Chapman          2010-04-02  721  			l2tp_session_set_header_len(session, tunnel->version);
fd558d186df2c13 James Chapman          2010-04-02  722  		}
fd558d186df2c13 James Chapman          2010-04-02  723  	} else {
fd558d186df2c13 James Chapman          2010-04-02  724  		/* No sequence numbers.
fd558d186df2c13 James Chapman          2010-04-02  725  		 * If user has configured mandatory sequence numbers, discard.
fd558d186df2c13 James Chapman          2010-04-02  726  		 */
fd558d186df2c13 James Chapman          2010-04-02  727  		if (session->recv_seq) {
a4ca44fa578c7c7 Joe Perches            2012-05-16  728  			l2tp_warn(session, L2TP_MSG_SEQ,
a4ca44fa578c7c7 Joe Perches            2012-05-16  729  				  "%s: recv data has no seq numbers when required. Discarding.\n",
a4ca44fa578c7c7 Joe Perches            2012-05-16  730  				  session->name);
7b7c0719cd7afee Tom Parkin             2013-03-19  731  			atomic_long_inc(&session->stats.rx_seq_discards);
fd558d186df2c13 James Chapman          2010-04-02  732  			goto discard;
fd558d186df2c13 James Chapman          2010-04-02  733  		}
fd558d186df2c13 James Chapman          2010-04-02  734  
fd558d186df2c13 James Chapman          2010-04-02  735  		/* If we're the LAC and we're sending sequence numbers, the
fd558d186df2c13 James Chapman          2010-04-02  736  		 * LNS has requested that we no longer send sequence numbers.
fd558d186df2c13 James Chapman          2010-04-02  737  		 * If we're the LNS and we're sending sequence numbers, the
fd558d186df2c13 James Chapman          2010-04-02  738  		 * LAC is broken. Discard the frame.
fd558d186df2c13 James Chapman          2010-04-02  739  		 */
6c0ec37b8283463 Tom Parkin             2020-07-23  740  		if (!session->lns_mode && session->send_seq) {
a4ca44fa578c7c7 Joe Perches            2012-05-16  741  			l2tp_info(session, L2TP_MSG_SEQ,
fd558d186df2c13 James Chapman          2010-04-02  742  				  "%s: requested to disable seq numbers by LNS\n",
fd558d186df2c13 James Chapman          2010-04-02  743  				  session->name);
fd558d186df2c13 James Chapman          2010-04-02  744  			session->send_seq = 0;
f7faffa3ff8ef6a James Chapman          2010-04-02  745  			l2tp_session_set_header_len(session, tunnel->version);
fd558d186df2c13 James Chapman          2010-04-02  746  		} else if (session->send_seq) {
a4ca44fa578c7c7 Joe Perches            2012-05-16  747  			l2tp_warn(session, L2TP_MSG_SEQ,
a4ca44fa578c7c7 Joe Perches            2012-05-16  748  				  "%s: recv data has no seq numbers when required. Discarding.\n",
a4ca44fa578c7c7 Joe Perches            2012-05-16  749  				  session->name);
7b7c0719cd7afee Tom Parkin             2013-03-19  750  			atomic_long_inc(&session->stats.rx_seq_discards);
fd558d186df2c13 James Chapman          2010-04-02  751  			goto discard;
fd558d186df2c13 James Chapman          2010-04-02  752  		}
fd558d186df2c13 James Chapman          2010-04-02  753  	}
fd558d186df2c13 James Chapman          2010-04-02  754  
900631ee6a2651d James Chapman          2018-01-03  755  	/* Session data offset is defined only for L2TPv2 and is
900631ee6a2651d James Chapman          2018-01-03  756  	 * indicated by an optional 16-bit value in the header.
f7faffa3ff8ef6a James Chapman          2010-04-02  757  	 */
f7faffa3ff8ef6a James Chapman          2010-04-02  758  	if (tunnel->version == L2TP_HDR_VER_2) {
fd558d186df2c13 James Chapman          2010-04-02  759  		/* If offset bit set, skip it. */
fd558d186df2c13 James Chapman          2010-04-02  760  		if (hdrflags & L2TP_HDRFLAG_O) {
fd558d186df2c13 James Chapman          2010-04-02  761  			offset = ntohs(*(__be16 *)ptr);
fd558d186df2c13 James Chapman          2010-04-02  762  			ptr += 2 + offset;
fd558d186df2c13 James Chapman          2010-04-02  763  		}
900631ee6a2651d James Chapman          2018-01-03  764  	}
fd558d186df2c13 James Chapman          2010-04-02  765  
fd558d186df2c13 James Chapman          2010-04-02  766  	offset = ptr - optr;
fd558d186df2c13 James Chapman          2010-04-02  767  	if (!pskb_may_pull(skb, offset))
fd558d186df2c13 James Chapman          2010-04-02  768  		goto discard;
fd558d186df2c13 James Chapman          2010-04-02  769  
fd558d186df2c13 James Chapman          2010-04-02  770  	__skb_pull(skb, offset);
fd558d186df2c13 James Chapman          2010-04-02  771  
fd558d186df2c13 James Chapman          2010-04-02  772  	/* Prepare skb for adding to the session's reorder_q.  Hold
fd558d186df2c13 James Chapman          2010-04-02  773  	 * packets for max reorder_timeout or 1 second if not
fd558d186df2c13 James Chapman          2010-04-02  774  	 * reordering.
fd558d186df2c13 James Chapman          2010-04-02  775  	 */
fd558d186df2c13 James Chapman          2010-04-02  776  	L2TP_SKB_CB(skb)->length = length;
fd558d186df2c13 James Chapman          2010-04-02  777  	L2TP_SKB_CB(skb)->expires = jiffies +
fd558d186df2c13 James Chapman          2010-04-02  778  		(session->reorder_timeout ? session->reorder_timeout : HZ);
fd558d186df2c13 James Chapman          2010-04-02  779  
fd558d186df2c13 James Chapman          2010-04-02  780  	/* Add packet to the session's receive queue. Reordering is done here, if
fd558d186df2c13 James Chapman          2010-04-02  781  	 * enabled. Saved L2TP protocol info is stored in skb->sb[].
fd558d186df2c13 James Chapman          2010-04-02  782  	 */
fd558d186df2c13 James Chapman          2010-04-02  783  	if (L2TP_SKB_CB(skb)->has_seq) {
b6dc01a43aaca24 James Chapman          2013-07-02  784  		if (l2tp_recv_data_seq(session, skb))
fd558d186df2c13 James Chapman          2010-04-02  785  			goto discard;
fd558d186df2c13 James Chapman          2010-04-02  786  	} else {
fd558d186df2c13 James Chapman          2010-04-02  787  		/* No sequence numbers. Add the skb to the tail of the
fd558d186df2c13 James Chapman          2010-04-02  788  		 * reorder queue. This ensures that it will be
fd558d186df2c13 James Chapman          2010-04-02  789  		 * delivered after all previous sequenced skbs.
fd558d186df2c13 James Chapman          2010-04-02  790  		 */
fd558d186df2c13 James Chapman          2010-04-02  791  		skb_queue_tail(&session->reorder_q, skb);
fd558d186df2c13 James Chapman          2010-04-02  792  	}
fd558d186df2c13 James Chapman          2010-04-02  793  
fd558d186df2c13 James Chapman          2010-04-02  794  	/* Try to dequeue as many skbs from reorder_q as we can. */
fd558d186df2c13 James Chapman          2010-04-02  795  	l2tp_recv_dequeue(session);
fd558d186df2c13 James Chapman          2010-04-02  796  
f7faffa3ff8ef6a James Chapman          2010-04-02  797  	return;
fd558d186df2c13 James Chapman          2010-04-02  798  
fd558d186df2c13 James Chapman          2010-04-02  799  discard:
7b7c0719cd7afee Tom Parkin             2013-03-19  800  	atomic_long_inc(&session->stats.rx_errors);
fd558d186df2c13 James Chapman          2010-04-02  801  	kfree_skb(skb);
f7faffa3ff8ef6a James Chapman          2010-04-02  802  }
ca7885dbcd899e6 Tom Parkin             2020-07-28  803  EXPORT_SYMBOL_GPL(l2tp_recv_common);
f7faffa3ff8ef6a James Chapman          2010-04-02  804  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--FCuugMFkClbJLl1L
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
0JkBAA==

--FCuugMFkClbJLl1L--
