Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09007244922
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgHNLnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbgHNLkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:40:03 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BCC061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:02 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k8so7669453wma.2
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o3jAZd7c1oBpBu0C6522rROyUMepx4fJzupW06MiS44=;
        b=tKmzw9/U/7OCk7rIn89aaqxIEYBzomj5DG0IWlNSn0wf1QezFX3qbml55jtkZ/Pswx
         KrCOTBlr7Eow3keZB1U3Lknv1iLAv2RSETXXXLbYXONBVj+vsTPQ5MW3g/PoGLpOnj6Y
         XlVr1YfrZj9l0CXCOzBsR80X9iPrAx87cWSKlv4WtwnwpEt22FyK5vTVpGQYnVwKiH87
         ncn6dRldLOoEw7ASeZpSIWpeYgY5CYZFKA/Z1pRdxjC81Uf2watAV9SHCF86iJpSUrJ0
         CHobHOhduZI4l4NA775gr+NEv7KJUJ6qoYrdzsDBKaRAuxdOD9PFnR6vg9SK3/75aNKT
         CNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o3jAZd7c1oBpBu0C6522rROyUMepx4fJzupW06MiS44=;
        b=cOxFjmo+jQb0LffQugzLa+wLqE41NMEcO+mn3lyWp8be2wD6dKEPW8mDM6ML465EUC
         4C8h7Wrg3S4jIgiaZ47C5L92TDOi2+MwRVNzfUd0FWa19l8jZOub/pkaJNScZE5DhGWU
         FnEhhBNCXMJ9sO+wIuGEBudTjcUr7m2XyFwa5r9RxPBrs92wnGPmugDjcaXrvEE4uPZH
         V5Mq1GViqd8ehQ8fxgmkLWgp20ZkDaUCLumMCSPPBhc83PNJWFRKrlnzRG6BkZGVB4I5
         9cJHXIP+w689n1VsdL56c7cPOwFGGzaEEp6Y3JEzYms7gZq6YBD+R2vS0MqVCw4ro/A1
         H4Jg==
X-Gm-Message-State: AOAM530OyrGaGIlc8gtWgR+fp0sCInMQOQQ3J/WwuBYnR7P3IE5d03T6
        oBe3yaKZrai5sJPQm0s+QHiziQ==
X-Google-Smtp-Source: ABdhPJxRhG5gQ8DbCeYj47+2K7UkWEtcdp3y5cleOqlXlkR6LyOdLwbIwBVq18dqNzrrgd2n88aQZQ==
X-Received: by 2002:a1c:b787:: with SMTP id h129mr2206458wmf.93.1597405201058;
        Fri, 14 Aug 2020 04:40:01 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:40:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        Fabrice Bellet <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding style issues
Date:   Fri, 14 Aug 2020 12:39:15 +0100
Message-Id: <20200814113933.1903438-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 - Ensure spaces appear after {for, if, while, etc}
 - Ensure spaces to not appear after '('
 - Ensure spaces to not appear before ')'
 - Ensure spaces appear between ')' and '{'
 - Ensure spaces appear after ','
 - Ensure spaces do not appear before ','
 - Ensure spaces appear either side of '='
 - Ensure '{'s which open functions are on a new line
 - Remove trailing whitespace

There are still a whole host of issues with this file, but this
patch certainly breaks the back of them.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Benjamin Reed <breed@users.sourceforge.net>
Cc: Javier Achirica <achirica@users.sourceforge.net>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Fabrice Bellet <fabrice@bellet.info>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/cisco/airo.c | 897 ++++++++++++++++--------------
 1 file changed, 467 insertions(+), 430 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 8002a4268e03e..dd78c415d6e76 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -321,8 +321,8 @@ static int do8bitIO /* = 0 */;
 #define CMD_DELTLV	0x002b
 #define CMD_FINDNEXTTLV	0x002c
 #define CMD_PSPNODES	0x0030
-#define CMD_SETCW	0x0031    
-#define CMD_SETPCF	0x0032    
+#define CMD_SETCW	0x0031
+#define CMD_SETPCF	0x0032
 #define CMD_SETPHYREG	0x003e
 #define CMD_TXTEST	0x003f
 #define MAC_ENABLETX	0x0101
@@ -433,7 +433,7 @@ static int do8bitIO /* = 0 */;
 #define STATUS_INTS (EV_AWAKE|EV_LINK|EV_TXEXC|EV_TX|EV_TXCPY|EV_RX|EV_MIC)
 
 #ifdef CHECK_UNKNOWN_INTS
-#define IGNORE_INTS ( EV_CMD | EV_UNKNOWN)
+#define IGNORE_INTS (EV_CMD | EV_UNKNOWN)
 #else
 #define IGNORE_INTS (~STATUS_INTS)
 #endif
@@ -1107,9 +1107,9 @@ static const char version[] = "airo.c 0.6 (Ben Reed & Javier Achirica)";
 
 struct airo_info;
 
-static int get_dec_u16( char *buffer, int *start, int limit );
-static void OUT4500( struct airo_info *, u16 reg, u16 value );
-static unsigned short IN4500( struct airo_info *, u16 reg );
+static int get_dec_u16(char *buffer, int *start, int limit);
+static void OUT4500(struct airo_info *, u16 reg, u16 value);
+static unsigned short IN4500(struct airo_info *, u16 reg);
 static u16 setup_card(struct airo_info*, u8 *mac, int lock);
 static int enable_MAC(struct airo_info *ai, int lock);
 static void disable_MAC(struct airo_info *ai, int lock);
@@ -1127,24 +1127,24 @@ static int PC4500_accessrid(struct airo_info*, u16 rid, u16 accmd);
 static int PC4500_readrid(struct airo_info*, u16 rid, void *pBuf, int len, int lock);
 static int PC4500_writerid(struct airo_info*, u16 rid, const void
 			   *pBuf, int len, int lock);
-static int do_writerid( struct airo_info*, u16 rid, const void *rid_data,
-			int len, int dummy );
+static int do_writerid(struct airo_info*, u16 rid, const void *rid_data,
+			int len, int dummy);
 static u16 transmit_allocate(struct airo_info*, int lenPayload, int raw);
 static int transmit_802_3_packet(struct airo_info*, int len, char *pPacket);
 static int transmit_802_11_packet(struct airo_info*, int len, char *pPacket);
 
-static int mpi_send_packet (struct net_device *dev);
+static int mpi_send_packet(struct net_device *dev);
 static void mpi_unmap_card(struct pci_dev *pci);
 static void mpi_receive_802_3(struct airo_info *ai);
 static void mpi_receive_802_11(struct airo_info *ai);
-static int waitbusy (struct airo_info *ai);
+static int waitbusy(struct airo_info *ai);
 
-static irqreturn_t airo_interrupt( int irq, void* dev_id);
+static irqreturn_t airo_interrupt(int irq, void* dev_id);
 static int airo_thread(void *data);
-static void timer_func( struct net_device *dev );
+static void timer_func(struct net_device *dev);
 static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
-static struct iw_statistics *airo_get_wireless_stats (struct net_device *dev);
-static void airo_read_wireless_stats (struct airo_info *local);
+static struct iw_statistics *airo_get_wireless_stats(struct net_device *dev);
+static void airo_read_wireless_stats(struct airo_info *local);
 #ifdef CISCO_EXT
 static int readrids(struct net_device *dev, aironet_ioctl *comp);
 static int writerids(struct net_device *dev, aironet_ioctl *comp);
@@ -1155,8 +1155,8 @@ static int micsetup(struct airo_info *ai);
 static int encapsulate(struct airo_info *ai, etherHead *pPacket, MICBuffer *buffer, int len);
 static int decapsulate(struct airo_info *ai, MICBuffer *mic, etherHead *pPacket, u16 payLen);
 
-static u8 airo_rssi_to_dbm (tdsRssiEntry *rssi_rid, u8 rssi);
-static u8 airo_dbm_to_pct (tdsRssiEntry *rssi_rid, u8 dbm);
+static u8 airo_rssi_to_dbm(tdsRssiEntry *rssi_rid, u8 rssi);
+static u8 airo_dbm_to_pct(tdsRssiEntry *rssi_rid, u8 dbm);
 
 static void airo_networks_free(struct airo_info *ai);
 
@@ -1261,16 +1261,16 @@ static inline int bap_read(struct airo_info *ai, __le16 *pu16Dst, int bytelen,
 	return ai->bap_read(ai, pu16Dst, bytelen, whichbap);
 }
 
-static int setup_proc_entry( struct net_device *dev,
-			     struct airo_info *apriv );
-static int takedown_proc_entry( struct net_device *dev,
-				struct airo_info *apriv );
+static int setup_proc_entry(struct net_device *dev,
+			     struct airo_info *apriv);
+static int takedown_proc_entry(struct net_device *dev,
+				struct airo_info *apriv);
 
 static int cmdreset(struct airo_info *ai);
-static int setflashmode (struct airo_info *ai);
-static int flashgchar(struct airo_info *ai,int matchbyte,int dwelltime);
+static int setflashmode(struct airo_info *ai);
+static int flashgchar(struct airo_info *ai, int matchbyte, int dwelltime);
 static int flashputbuf(struct airo_info *ai);
-static int flashrestart(struct airo_info *ai,struct net_device *dev);
+static int flashrestart(struct airo_info *ai, struct net_device *dev);
 
 #define airo_print(type, name, fmt, args...) \
 	printk(type DRV_NAME "(%s): " fmt "\n", name, ##args)
@@ -1294,14 +1294,14 @@ static int flashrestart(struct airo_info *ai,struct net_device *dev);
  ***********************************************************************
  */
 
-static int RxSeqValid (struct airo_info *ai,miccntx *context,int mcast,u32 micSeq);
+static int RxSeqValid(struct airo_info *ai, miccntx *context, int mcast, u32 micSeq);
 static void MoveWindow(miccntx *context, u32 micSeq);
 static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 			   struct crypto_sync_skcipher *tfm);
 static void emmh32_init(emmh32_context *context);
 static void emmh32_update(emmh32_context *context, u8 *pOctets, int len);
 static void emmh32_final(emmh32_context *context, u8 digest[4]);
-static int flashpchar(struct airo_info *ai,int byte,int dwelltime);
+static int flashpchar(struct airo_info *ai, int byte, int dwelltime);
 
 static void age_mic_context(miccntx *cur, miccntx *old, u8 *key, int key_len,
 			    struct crypto_sync_skcipher *tfm)
@@ -1361,7 +1361,8 @@ static void micinit(struct airo_info *ai)
 
 /* micsetup - Get ready for business */
 
-static int micsetup(struct airo_info *ai) {
+static int micsetup(struct airo_info *ai)
+{
 	int i;
 
 	if (ai->tfm == NULL)
@@ -1373,32 +1374,32 @@ static int micsetup(struct airo_info *ai) {
                 return ERROR;
         }
 
-	for (i=0; i < NUM_MODULES; i++) {
-		memset(&ai->mod[i].mCtx,0,sizeof(miccntx));
-		memset(&ai->mod[i].uCtx,0,sizeof(miccntx));
+	for (i = 0; i < NUM_MODULES; i++) {
+		memset(&ai->mod[i].mCtx, 0, sizeof(miccntx));
+		memset(&ai->mod[i].uCtx, 0, sizeof(miccntx));
 	}
 	return SUCCESS;
 }
 
-static const u8 micsnap[] = {0xAA,0xAA,0x03,0x00,0x40,0x96,0x00,0x02};
+static const u8 micsnap[] = {0xAA, 0xAA, 0x03, 0x00, 0x40, 0x96, 0x00, 0x02};
 
 /*===========================================================================
  * Description: Mic a packet
- *    
+ *
  *      Inputs: etherHead * pointer to an 802.3 frame
- *    
+ *
  *     Returns: BOOLEAN if successful, otherwise false.
  *             PacketTxLen will be updated with the mic'd packets size.
  *
  *    Caveats: It is assumed that the frame buffer will already
  *             be big enough to hold the largets mic message possible.
  *            (No memory allocation is done here).
- *  
+ *
  *    Author: sbraneky (10/15/01)
  *    Merciless hacks by rwilcher (1/14/02)
  */
 
-static int encapsulate(struct airo_info *ai ,etherHead *frame, MICBuffer *mic, int payLen)
+static int encapsulate(struct airo_info *ai, etherHead *frame, MICBuffer *mic, int payLen)
 {
 	miccntx   *context;
 
@@ -1409,7 +1410,7 @@ static int encapsulate(struct airo_info *ai ,etherHead *frame, MICBuffer *mic, i
 		context = &ai->mod[0].mCtx;
 	else
 		context = &ai->mod[0].uCtx;
-  
+
 	if (!context->valid)
 		return ERROR;
 
@@ -1422,10 +1423,10 @@ static int encapsulate(struct airo_info *ai ,etherHead *frame, MICBuffer *mic, i
 	context->tx += 2;
 
 	emmh32_init(&context->seed); // Mic the packet
-	emmh32_update(&context->seed,frame->da,ETH_ALEN * 2); // DA,SA
-	emmh32_update(&context->seed,(u8*)&mic->typelen,10); // Type/Length and Snap
-	emmh32_update(&context->seed,(u8*)&mic->seq,sizeof(mic->seq)); //SEQ
-	emmh32_update(&context->seed,(u8*)(frame + 1),payLen); //payload
+	emmh32_update(&context->seed, frame->da, ETH_ALEN * 2); // DA, SA
+	emmh32_update(&context->seed, (u8*)&mic->typelen, 10); // Type/Length and Snap
+	emmh32_update(&context->seed, (u8*)&mic->seq, sizeof(mic->seq)); //SEQ
+	emmh32_update(&context->seed, (u8*)(frame + 1), payLen); //payload
 	emmh32_final(&context->seed, (u8*)&mic->mic);
 
 	/*    New Type/length ?????????? */
@@ -1444,11 +1445,11 @@ typedef enum {
 /*===========================================================================
  *  Description: Decapsulates a MIC'd packet and returns the 802.3 packet
  *               (removes the MIC stuff) if packet is a valid packet.
- *      
- *       Inputs: etherHead  pointer to the 802.3 packet             
- *     
+ *
+ *       Inputs: etherHead  pointer to the 802.3 packet
+ *
  *      Returns: BOOLEAN - TRUE if packet should be dropped otherwise FALSE
- *     
+ *
  *      Author: sbraneky (10/15/01)
  *    Merciless hacks by rwilcher (1/14/02)
  *---------------------------------------------------------------------------
@@ -1488,35 +1489,35 @@ static int decapsulate(struct airo_info *ai, MICBuffer *mic, etherHead *eth, u16
 	//Now do the mic error checking.
 
 	//Receive seq must be odd
-	if ( (micSEQ & 1) == 0 ) {
+	if ((micSEQ & 1) == 0) {
 		ai->micstats.rxWrongSequence++;
 		return ERROR;
 	}
 
 	for (i = 0; i < NUM_MODULES; i++) {
 		int mcast = eth->da[0] & 1;
-		//Determine proper context 
+		//Determine proper context
 		context = mcast ? &ai->mod[i].mCtx : &ai->mod[i].uCtx;
-	
+
 		//Make sure context is valid
 		if (!context->valid) {
 			if (i == 0)
 				micError = NOMICPLUMMED;
-			continue;                
+			continue;
 		}
-	       	//DeMic it 
+		//DeMic it
 
 		if (!mic->typelen)
 			mic->typelen = htons(payLen + sizeof(MICBuffer) - 2);
-	
+
 		emmh32_init(&context->seed);
-		emmh32_update(&context->seed, eth->da, ETH_ALEN*2); 
-		emmh32_update(&context->seed, (u8 *)&mic->typelen, sizeof(mic->typelen)+sizeof(mic->u.snap)); 
-		emmh32_update(&context->seed, (u8 *)&mic->seq,sizeof(mic->seq));	
-		emmh32_update(&context->seed, (u8 *)(eth + 1),payLen);	
+		emmh32_update(&context->seed, eth->da, ETH_ALEN*2);
+		emmh32_update(&context->seed, (u8 *)&mic->typelen, sizeof(mic->typelen)+sizeof(mic->u.snap));
+		emmh32_update(&context->seed, (u8 *)&mic->seq, sizeof(mic->seq));
+		emmh32_update(&context->seed, (u8 *)(eth + 1), payLen);
 		//Calculate MIC
 		emmh32_final(&context->seed, digest);
-	
+
 		if (memcmp(digest, &mic->mic, 4)) { //Make sure the mics match
 		  //Invalid Mic
 			if (i == 0)
@@ -1547,22 +1548,22 @@ static int decapsulate(struct airo_info *ai, MICBuffer *mic, etherHead *eth, u16
 /*===========================================================================
  * Description:  Checks the Rx Seq number to make sure it is valid
  *               and hasn't already been received
- *   
+ *
  *     Inputs: miccntx - mic context to check seq against
  *             micSeq  - the Mic seq number
- *   
- *    Returns: TRUE if valid otherwise FALSE. 
+ *
+ *    Returns: TRUE if valid otherwise FALSE.
  *
  *    Author: sbraneky (10/15/01)
  *    Merciless hacks by rwilcher (1/14/02)
  *---------------------------------------------------------------------------
  */
 
-static int RxSeqValid (struct airo_info *ai,miccntx *context,int mcast,u32 micSeq)
+static int RxSeqValid(struct airo_info *ai, miccntx *context, int mcast, u32 micSeq)
 {
-	u32 seq,index;
+	u32 seq, index;
 
-	//Allow for the ap being rebooted - if it is then use the next 
+	//Allow for the ap being rebooted - if it is then use the next
 	//sequence number of the current sequence number - might go backwards
 
 	if (mcast) {
@@ -1583,10 +1584,10 @@ static int RxSeqValid (struct airo_info *ai,miccntx *context,int mcast,u32 micSe
 	//Too old of a SEQ number to check.
 	if ((s32)seq < 0)
 		return ERROR;
-    
-	if ( seq > 64 ) {
+
+	if (seq > 64) {
 		//Window is infinite forward
-		MoveWindow(context,micSeq);
+		MoveWindow(context, micSeq);
 		return SUCCESS;
 	}
 
@@ -1599,7 +1600,7 @@ static int RxSeqValid (struct airo_info *ai,miccntx *context,int mcast,u32 micSe
 		//Add seqence number to the list of received numbers.
 		context->rx |= index;
 
-		MoveWindow(context,micSeq);
+		MoveWindow(context, micSeq);
 
 		return SUCCESS;
 	}
@@ -1613,7 +1614,7 @@ static void MoveWindow(miccntx *context, u32 micSeq)
 	//Move window if seq greater than the middle of the window
 	if (micSeq > context->window) {
 		shift = (micSeq - context->window) >> 1;
-    
+
 		    //Shift out old
 		if (shift < 32)
 			context->rx >>= shift;
@@ -1638,7 +1639,7 @@ static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 {
   /* take the keying material, expand if necessary, truncate at 16-bytes */
   /* run through AES counter mode to generate context->coeff[] */
-  
+
 	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
 	struct scatterlist sg;
 	u8 iv[AES_BLOCK_SIZE] = {};
@@ -1669,11 +1670,11 @@ static void emmh32_init(emmh32_context *context)
 static void emmh32_update(emmh32_context *context, u8 *pOctets, int len)
 {
 	int	coeff_position, byte_position;
-  
+
 	if (len == 0) return;
-  
+
 	coeff_position = context->position >> 2;
-  
+
 	/* deal with partial 32-bit word left over from last update */
 	byte_position = context->position & 3;
 	if (byte_position) {
@@ -1712,12 +1713,12 @@ static void emmh32_final(emmh32_context *context, u8 digest[4])
 {
 	int	coeff_position, byte_position;
 	u32	val;
-  
+
 	u64 sum, utmp;
 	s64 stmp;
 
 	coeff_position = context->position >> 2;
-  
+
 	/* deal with partial 32-bit word left over from last update */
 	byte_position = context->position & 3;
 	if (byte_position) {
@@ -1750,7 +1751,7 @@ static int readBSSListRid(struct airo_info *ai, int first,
 	if (first == 1) {
 		if (ai->flags & FLAG_RADIO_MASK) return -ENETDOWN;
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.cmd=CMD_LISTBSS;
+		cmd.cmd = CMD_LISTBSS;
 		if (down_interruptible(&ai->sem))
 			return -ERESTARTSYS;
 		ai->list_bss_task = current;
@@ -1815,7 +1816,7 @@ static inline void checkThrottle(struct airo_info *ai)
 	int i;
 /* Old hardware had a limit on encryption speed */
 	if (ai->config.authType != AUTH_OPEN && maxencrypt) {
-		for(i=0; i<8; i++) {
+		for (i = 0; i<8; i++) {
 			if (ai->config.rates[i] > maxencrypt) {
 				ai->config.rates[i] = 0;
 			}
@@ -1840,7 +1841,7 @@ static int writeConfigRid(struct airo_info *ai, int lock)
 	else
 		clear_bit(FLAG_ADHOC, &ai->flags);
 
-	return PC4500_writerid( ai, RID_CONFIG, &cfgr, sizeof(cfgr), lock);
+	return PC4500_writerid(ai, RID_CONFIG, &cfgr, sizeof(cfgr), lock);
 }
 
 static int readStatusRid(struct airo_info *ai, StatusRid *statr, int lock)
@@ -1871,7 +1872,8 @@ static void try_auto_wep(struct airo_info *ai)
 	}
 }
 
-static int airo_open(struct net_device *dev) {
+static int airo_open(struct net_device *dev)
+{
 	struct airo_info *ai = dev->ml_priv;
 	int rc = 0;
 
@@ -1947,7 +1949,7 @@ static netdev_tx_t mpi_start_xmit(struct sk_buff *skb,
 	spin_lock_irqsave(&ai->aux_lock, flags);
 	skb_queue_tail (&ai->txq, skb);
 	pending = test_bit(FLAG_PENDING_XMIT, &ai->flags);
-	spin_unlock_irqrestore(&ai->aux_lock,flags);
+	spin_unlock_irqrestore(&ai->aux_lock, flags);
 	netif_wake_queue (dev);
 
 	if (pending == 0) {
@@ -2096,7 +2098,8 @@ static void get_tx_error(struct airo_info *ai, s32 fid)
 	}
 }
 
-static void airo_end_xmit(struct net_device *dev) {
+static void airo_end_xmit(struct net_device *dev)
+{
 	u16 status;
 	int i;
 	struct airo_info *priv = dev->ml_priv;
@@ -2110,7 +2113,7 @@ static void airo_end_xmit(struct net_device *dev) {
 	up(&priv->sem);
 
 	i = 0;
-	if ( status == SUCCESS ) {
+	if (status == SUCCESS) {
 		netif_trans_update(dev);
 		for (; i < MAX_FIDS / 2 && (priv->fids[i] & 0xffff0000); i++);
 	} else {
@@ -2130,7 +2133,7 @@ static netdev_tx_t airo_start_xmit(struct sk_buff *skb,
 	struct airo_info *priv = dev->ml_priv;
 	u32 *fids = priv->fids;
 
-	if ( skb == NULL ) {
+	if (skb == NULL) {
 		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return NETDEV_TX_OK;
 	}
@@ -2140,10 +2143,10 @@ static netdev_tx_t airo_start_xmit(struct sk_buff *skb,
 	}
 
 	/* Find a vacant FID */
-	for( i = 0; i < MAX_FIDS / 2 && (fids[i] & 0xffff0000); i++ );
-	for( j = i + 1; j < MAX_FIDS / 2 && (fids[j] & 0xffff0000); j++ );
+	for (i = 0; i < MAX_FIDS / 2 && (fids[i] & 0xffff0000); i++);
+	for (j = i + 1; j < MAX_FIDS / 2 && (fids[j] & 0xffff0000); j++);
 
-	if ( j >= MAX_FIDS / 2 ) {
+	if (j >= MAX_FIDS / 2) {
 		netif_stop_queue(dev);
 
 		if (i == MAX_FIDS / 2) {
@@ -2167,7 +2170,8 @@ static netdev_tx_t airo_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static void airo_end_xmit11(struct net_device *dev) {
+static void airo_end_xmit11(struct net_device *dev)
+{
 	u16 status;
 	int i;
 	struct airo_info *priv = dev->ml_priv;
@@ -2181,7 +2185,7 @@ static void airo_end_xmit11(struct net_device *dev) {
 	up(&priv->sem);
 
 	i = MAX_FIDS / 2;
-	if ( status == SUCCESS ) {
+	if (status == SUCCESS) {
 		netif_trans_update(dev);
 		for (; i < MAX_FIDS && (priv->fids[i] & 0xffff0000); i++);
 	} else {
@@ -2208,7 +2212,7 @@ static netdev_tx_t airo_start_xmit11(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	if ( skb == NULL ) {
+	if (skb == NULL) {
 		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return NETDEV_TX_OK;
 	}
@@ -2218,10 +2222,10 @@ static netdev_tx_t airo_start_xmit11(struct sk_buff *skb,
 	}
 
 	/* Find a vacant FID */
-	for( i = MAX_FIDS / 2; i < MAX_FIDS && (fids[i] & 0xffff0000); i++ );
-	for( j = i + 1; j < MAX_FIDS && (fids[j] & 0xffff0000); j++ );
+	for (i = MAX_FIDS / 2; i < MAX_FIDS && (fids[i] & 0xffff0000); i++);
+	for (j = i + 1; j < MAX_FIDS && (fids[j] & 0xffff0000); j++);
 
-	if ( j >= MAX_FIDS ) {
+	if (j >= MAX_FIDS) {
 		netif_stop_queue(dev);
 
 		if (i == MAX_FIDS) {
@@ -2295,19 +2299,21 @@ static struct net_device_stats *airo_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
-static void airo_set_promisc(struct airo_info *ai) {
+static void airo_set_promisc(struct airo_info *ai)
+{
 	Cmd cmd;
 	Resp rsp;
 
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.cmd=CMD_SETMODE;
+	cmd.cmd = CMD_SETMODE;
 	clear_bit(JOB_PROMISC, &ai->jobs);
 	cmd.parm0=(ai->flags&IFF_PROMISC) ? PROMISC : NOPROMISC;
 	issuecommand(ai, &cmd, &rsp);
 	up(&ai->sem);
 }
 
-static void airo_set_multicast_list(struct net_device *dev) {
+static void airo_set_multicast_list(struct net_device *dev)
+{
 	struct airo_info *ai = dev->ml_priv;
 
 	if ((dev->flags ^ ai->flags) & IFF_PROMISC) {
@@ -2357,7 +2363,8 @@ static void del_airo_dev(struct airo_info *ai)
 		list_del(&ai->dev_list);
 }
 
-static int airo_close(struct net_device *dev) {
+static int airo_close(struct net_device *dev)
+{
 	struct airo_info *ai = dev->ml_priv;
 
 	netif_stop_queue(dev);
@@ -2372,7 +2379,7 @@ static int airo_close(struct net_device *dev) {
 		set_bit(FLAG_RADIO_DOWN, &ai->flags);
 		disable_MAC(ai, 1);
 #endif
-		disable_interrupts( ai );
+		disable_interrupts(ai);
 
 		free_irq(dev->irq, dev);
 
@@ -2382,16 +2389,16 @@ static int airo_close(struct net_device *dev) {
 	return 0;
 }
 
-void stop_airo_card( struct net_device *dev, int freeres )
+void stop_airo_card(struct net_device *dev, int freeres)
 {
 	struct airo_info *ai = dev->ml_priv;
 
 	set_bit(FLAG_RADIO_DOWN, &ai->flags);
 	disable_MAC(ai, 1);
 	disable_interrupts(ai);
-	takedown_proc_entry( dev, ai );
+	takedown_proc_entry(dev, ai);
 	if (test_bit(FLAG_REGISTERED, &ai->flags)) {
-		unregister_netdev( dev );
+		unregister_netdev(dev);
 		if (ai->wifidev) {
 			unregister_netdev(ai->wifidev);
 			free_netdev(ai->wifidev);
@@ -2415,7 +2422,7 @@ void stop_airo_card( struct net_device *dev, int freeres )
 	kfree(ai->SSID);
 	if (freeres) {
 		/* PCMCIA frees this stuff, so only for PCI and ISA */
-	        release_region( dev->base_addr, 64 );
+		release_region(dev->base_addr, 64);
 		if (test_bit(FLAG_MPI, &ai->flags)) {
 			if (ai->pci)
 				mpi_unmap_card(ai->pci);
@@ -2429,7 +2436,7 @@ void stop_airo_card( struct net_device *dev, int freeres )
         }
 	crypto_free_sync_skcipher(ai->tfm);
 	del_airo_dev(ai);
-	free_netdev( dev );
+	free_netdev(dev);
 }
 
 EXPORT_SYMBOL(stop_airo_card);
@@ -2468,56 +2475,56 @@ static int mpi_init_descriptors (struct airo_info *ai)
 	/* Alloc  card RX descriptors */
 	netif_stop_queue(ai->dev);
 
-	memset(&rsp,0,sizeof(rsp));
-	memset(&cmd,0,sizeof(cmd));
+	memset(&rsp, 0, sizeof(rsp));
+	memset(&cmd, 0, sizeof(cmd));
 
 	cmd.cmd = CMD_ALLOCATEAUX;
 	cmd.parm0 = FID_RX;
 	cmd.parm1 = (ai->rxfids[0].card_ram_off - ai->pciaux);
 	cmd.parm2 = MPI_MAX_FIDS;
-	rc=issuecommand(ai, &cmd, &rsp);
+	rc = issuecommand(ai, &cmd, &rsp);
 	if (rc != SUCCESS) {
 		airo_print_err(ai->dev->name, "Couldn't allocate RX FID");
 		return rc;
 	}
 
-	for (i=0; i<MPI_MAX_FIDS; i++) {
+	for (i = 0; i<MPI_MAX_FIDS; i++) {
 		memcpy_toio(ai->rxfids[i].card_ram_off,
 			&ai->rxfids[i].rx_desc, sizeof(RxFid));
 	}
 
 	/* Alloc card TX descriptors */
 
-	memset(&rsp,0,sizeof(rsp));
-	memset(&cmd,0,sizeof(cmd));
+	memset(&rsp, 0, sizeof(rsp));
+	memset(&cmd, 0, sizeof(cmd));
 
 	cmd.cmd = CMD_ALLOCATEAUX;
 	cmd.parm0 = FID_TX;
 	cmd.parm1 = (ai->txfids[0].card_ram_off - ai->pciaux);
 	cmd.parm2 = MPI_MAX_FIDS;
 
-	for (i=0; i<MPI_MAX_FIDS; i++) {
+	for (i = 0; i<MPI_MAX_FIDS; i++) {
 		ai->txfids[i].tx_desc.valid = 1;
 		memcpy_toio(ai->txfids[i].card_ram_off,
 			&ai->txfids[i].tx_desc, sizeof(TxFid));
 	}
 	ai->txfids[i-1].tx_desc.eoc = 1; /* Last descriptor has EOC set */
 
-	rc=issuecommand(ai, &cmd, &rsp);
+	rc = issuecommand(ai, &cmd, &rsp);
 	if (rc != SUCCESS) {
 		airo_print_err(ai->dev->name, "Couldn't allocate TX FID");
 		return rc;
 	}
 
 	/* Alloc card Rid descriptor */
-	memset(&rsp,0,sizeof(rsp));
-	memset(&cmd,0,sizeof(cmd));
+	memset(&rsp, 0, sizeof(rsp));
+	memset(&cmd, 0, sizeof(cmd));
 
 	cmd.cmd = CMD_ALLOCATEAUX;
 	cmd.parm0 = RID_RW;
 	cmd.parm1 = (ai->config_desc.card_ram_off - ai->pciaux);
 	cmd.parm2 = 1; /* Magic number... */
-	rc=issuecommand(ai, &cmd, &rsp);
+	rc = issuecommand(ai, &cmd, &rsp);
 	if (rc != SUCCESS) {
 		airo_print_err(ai->dev->name, "Couldn't allocate RID");
 		return rc;
@@ -2589,7 +2596,7 @@ static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci)
 	vpackoff   = ai->shared;
 
 	/* RX descriptor setup */
-	for(i = 0; i < MPI_MAX_FIDS; i++) {
+	for (i = 0; i < MPI_MAX_FIDS; i++) {
 		ai->rxfids[i].pending = 0;
 		ai->rxfids[i].card_ram_off = pciaddroff;
 		ai->rxfids[i].virtual_host_addr = vpackoff;
@@ -2604,7 +2611,7 @@ static int mpi_map_card(struct airo_info *ai, struct pci_dev *pci)
 	}
 
 	/* TX descriptor setup */
-	for(i = 0; i < MPI_MAX_FIDS; i++) {
+	for (i = 0; i < MPI_MAX_FIDS; i++) {
 		ai->txfids[i].card_ram_off = pciaddroff;
 		ai->txfids[i].virtual_host_addr = vpackoff;
 		ai->txfids[i].tx_desc.valid = 1;
@@ -2674,7 +2681,7 @@ static void wifi_setup(struct net_device *dev)
 	dev->min_mtu            = 68;
 	dev->max_mtu            = MIC_MSGLEN_MAX;
 	dev->addr_len           = ETH_ALEN;
-	dev->tx_queue_len       = 100; 
+	dev->tx_queue_len       = 100;
 
 	eth_broadcast_addr(dev->broadcast);
 
@@ -2703,13 +2710,14 @@ static struct net_device *init_wifidev(struct airo_info *ai,
 	return dev;
 }
 
-static int reset_card( struct net_device *dev , int lock) {
+static int reset_card(struct net_device *dev, int lock)
+{
 	struct airo_info *ai = dev->ml_priv;
 
 	if (lock && down_interruptible(&ai->sem))
 		return -1;
 	waitbusy (ai);
-	OUT4500(ai,COMMAND,CMD_SOFTRESET);
+	OUT4500(ai, COMMAND, CMD_SOFTRESET);
 	msleep(200);
 	waitbusy (ai);
 	msleep(200);
@@ -2774,9 +2782,9 @@ static const struct net_device_ops mpi_netdev_ops = {
 };
 
 
-static struct net_device *_init_airo_card( unsigned short irq, int port,
+static struct net_device *_init_airo_card(unsigned short irq, int port,
 					   int is_pcmcia, struct pci_dev *pci,
-					   struct device *dmdev )
+					   struct device *dmdev)
 {
 	struct net_device *dev;
 	struct airo_info *ai;
@@ -2849,7 +2857,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 
 	if (probe) {
 		if (setup_card(ai, dev->dev_addr, 1) != SUCCESS) {
-			airo_print_err(dev->name, "MAC could not be enabled" );
+			airo_print_err(dev->name, "MAC could not be enabled");
 			rc = -EIO;
 			goto err_out_map;
 		}
@@ -2907,8 +2915,8 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 
 	/* Allocate the transmit buffers */
 	if (probe && !test_bit(FLAG_MPI,&ai->flags))
-		for( i = 0; i < MAX_FIDS; i++ )
-			ai->fids[i] = transmit_allocate(ai,AIRO_DEF_MTU,i>=MAX_FIDS/2);
+		for (i = 0; i < MAX_FIDS; i++)
+			ai->fids[i] = transmit_allocate(ai, AIRO_DEF_MTU, i>=MAX_FIDS/2);
 
 	if (setup_proc_entry(dev, dev->ml_priv) < 0)
 		goto err_out_wifi;
@@ -2929,7 +2937,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	}
 err_out_res:
 	if (!is_pcmcia)
-	        release_region( dev->base_addr, 64 );
+		release_region(dev->base_addr, 64);
 err_out_nets:
 	airo_networks_free(ai);
 err_out_free:
@@ -2938,15 +2946,16 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	return NULL;
 }
 
-struct net_device *init_airo_card( unsigned short irq, int port, int is_pcmcia,
+struct net_device *init_airo_card(unsigned short irq, int port, int is_pcmcia,
 				  struct device *dmdev)
 {
-	return _init_airo_card ( irq, port, is_pcmcia, NULL, dmdev);
+	return _init_airo_card (irq, port, is_pcmcia, NULL, dmdev);
 }
 
 EXPORT_SYMBOL(init_airo_card);
 
-static int waitbusy (struct airo_info *ai) {
+static int waitbusy (struct airo_info *ai)
+{
 	int delay = 0;
 	while ((IN4500(ai, COMMAND) & COMMAND_BUSY) && (delay < 10000)) {
 		udelay (10);
@@ -2956,7 +2965,7 @@ static int waitbusy (struct airo_info *ai) {
 	return delay < 10000;
 }
 
-int reset_airo_card( struct net_device *dev )
+int reset_airo_card(struct net_device *dev)
 {
 	int i;
 	struct airo_info *ai = dev->ml_priv;
@@ -2964,24 +2973,25 @@ int reset_airo_card( struct net_device *dev )
 	if (reset_card (dev, 1))
 		return -1;
 
-	if ( setup_card(ai, dev->dev_addr, 1 ) != SUCCESS ) {
+	if (setup_card(ai, dev->dev_addr, 1) != SUCCESS) {
 		airo_print_err(dev->name, "MAC could not be enabled");
 		return -1;
 	}
 	airo_print_info(dev->name, "MAC enabled %pM", dev->dev_addr);
 	/* Allocate the transmit buffers if needed */
 	if (!test_bit(FLAG_MPI,&ai->flags))
-		for( i = 0; i < MAX_FIDS; i++ )
-			ai->fids[i] = transmit_allocate (ai,AIRO_DEF_MTU,i>=MAX_FIDS/2);
+		for (i = 0; i < MAX_FIDS; i++)
+			ai->fids[i] = transmit_allocate (ai, AIRO_DEF_MTU, i>=MAX_FIDS/2);
 
-	enable_interrupts( ai );
+	enable_interrupts(ai);
 	netif_wake_queue(dev);
 	return 0;
 }
 
 EXPORT_SYMBOL(reset_airo_card);
 
-static void airo_send_event(struct net_device *dev) {
+static void airo_send_event(struct net_device *dev)
+{
 	struct airo_info *ai = dev->ml_priv;
 	union iwreq_data wrqu;
 	StatusRid status_rid;
@@ -2998,7 +3008,8 @@ static void airo_send_event(struct net_device *dev) {
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void airo_process_scan_results (struct airo_info *ai) {
+static void airo_process_scan_results (struct airo_info *ai)
+{
 	union iwreq_data	wrqu;
 	BSSListRid bss;
 	int rc;
@@ -3014,14 +3025,14 @@ static void airo_process_scan_results (struct airo_info *ai) {
 
 	/* Try to read the first entry of the scan result */
 	rc = PC4500_readrid(ai, ai->bssListFirst, &bss, ai->bssListRidLen, 0);
-	if((rc) || (bss.index == cpu_to_le16(0xffff))) {
+	if ((rc) || (bss.index == cpu_to_le16(0xffff))) {
 		/* No scan results */
 		goto out;
 	}
 
 	/* Read and parse all entries */
 	tmp_net = NULL;
-	while((!rc) && (bss.index != cpu_to_le16(0xffff))) {
+	while ((!rc) && (bss.index != cpu_to_le16(0xffff))) {
 		/* Grab a network off the free list */
 		if (!list_empty(&ai->network_free_list)) {
 			tmp_net = list_entry(ai->network_free_list.next,
@@ -3062,13 +3073,14 @@ static void airo_process_scan_results (struct airo_info *ai) {
 	wireless_send_event(ai->dev, SIOCGIWSCAN, &wrqu, NULL);
 }
 
-static int airo_thread(void *data) {
+static int airo_thread(void *data)
+{
 	struct net_device *dev = data;
 	struct airo_info *ai = dev->ml_priv;
 	int locked;
 
 	set_freezable();
-	while(1) {
+	while (1) {
 		/* make swsusp happy with our thread */
 		try_to_freeze();
 
@@ -3088,11 +3100,11 @@ static int airo_thread(void *data) {
 					break;
 				if (ai->expires || ai->scan_timeout) {
 					if (ai->scan_timeout &&
-							time_after_eq(jiffies,ai->scan_timeout)){
+							time_after_eq(jiffies, ai->scan_timeout)) {
 						set_bit(JOB_SCAN_RESULTS, &ai->jobs);
 						break;
 					} else if (ai->expires &&
-							time_after_eq(jiffies,ai->expires)){
+							time_after_eq(jiffies, ai->expires)) {
 						set_bit(JOB_AUTOWEP, &ai->jobs);
 						break;
 					}
@@ -3442,11 +3454,11 @@ static void airo_handle_tx(struct airo_info *ai, u16 status)
 
 		spin_lock_irqsave(&ai->aux_lock, flags);
 		if (!skb_queue_empty(&ai->txq)) {
-			spin_unlock_irqrestore(&ai->aux_lock,flags);
+			spin_unlock_irqrestore(&ai->aux_lock, flags);
 			mpi_send_packet(ai->dev);
 		} else {
 			clear_bit(FLAG_PENDING_XMIT, &ai->flags);
-			spin_unlock_irqrestore(&ai->aux_lock,flags);
+			spin_unlock_irqrestore(&ai->aux_lock, flags);
 			netif_wake_queue(ai->dev);
 		}
 		OUT4500(ai, EVACK, status & (EV_TX | EV_TXCPY | EV_TXEXC));
@@ -3526,9 +3538,9 @@ static irqreturn_t airo_interrupt(int irq, void *dev_id)
 		if (status & (EV_TX | EV_TXCPY | EV_TXEXC))
 			airo_handle_tx(ai, status);
 
-		if ( status & ~STATUS_INTS & ~IGNORE_INTS ) {
+		if (status & ~STATUS_INTS & ~IGNORE_INTS) {
 			airo_print_warn(ai->dev->name, "Got weird status %x",
-				status & ~STATUS_INTS & ~IGNORE_INTS );
+				status & ~STATUS_INTS & ~IGNORE_INTS);
 		}
 	}
 
@@ -3547,27 +3559,29 @@ static irqreturn_t airo_interrupt(int irq, void *dev_id)
  *  NOTE:  If use with 8bit mode and SMP bad things will happen!
  *         Why would some one do 8 bit IO in an SMP machine?!?
  */
-static void OUT4500( struct airo_info *ai, u16 reg, u16 val ) {
+static void OUT4500(struct airo_info *ai, u16 reg, u16 val)
+{
 	if (test_bit(FLAG_MPI,&ai->flags))
 		reg <<= 1;
-	if ( !do8bitIO )
-		outw( val, ai->dev->base_addr + reg );
+	if (!do8bitIO)
+		outw(val, ai->dev->base_addr + reg);
 	else {
-		outb( val & 0xff, ai->dev->base_addr + reg );
-		outb( val >> 8, ai->dev->base_addr + reg + 1 );
+		outb(val & 0xff, ai->dev->base_addr + reg);
+		outb(val >> 8, ai->dev->base_addr + reg + 1);
 	}
 }
 
-static u16 IN4500( struct airo_info *ai, u16 reg ) {
+static u16 IN4500(struct airo_info *ai, u16 reg)
+{
 	unsigned short rc;
 
 	if (test_bit(FLAG_MPI,&ai->flags))
 		reg <<= 1;
-	if ( !do8bitIO )
-		rc = inw( ai->dev->base_addr + reg );
+	if (!do8bitIO)
+		rc = inw(ai->dev->base_addr + reg);
 	else {
-		rc = inb( ai->dev->base_addr + reg );
-		rc += ((int)inb( ai->dev->base_addr + reg + 1 )) << 8;
+		rc = inb(ai->dev->base_addr + reg);
+		rc += ((int)inb(ai->dev->base_addr + reg + 1)) << 8;
 	}
 	return rc;
 }
@@ -3611,7 +3625,8 @@ static int enable_MAC(struct airo_info *ai, int lock)
 	return rc;
 }
 
-static void disable_MAC( struct airo_info *ai, int lock ) {
+static void disable_MAC(struct airo_info *ai, int lock)
+{
         Cmd cmd;
 	Resp rsp;
 
@@ -3630,13 +3645,15 @@ static void disable_MAC( struct airo_info *ai, int lock ) {
 		up(&ai->sem);
 }
 
-static void enable_interrupts( struct airo_info *ai ) {
+static void enable_interrupts(struct airo_info *ai)
+{
 	/* Enable the interrupts */
-	OUT4500( ai, EVINTEN, STATUS_INTS );
+	OUT4500(ai, EVINTEN, STATUS_INTS);
 }
 
-static void disable_interrupts( struct airo_info *ai ) {
-	OUT4500( ai, EVINTEN, 0 );
+static void disable_interrupts(struct airo_info *ai)
+{
+	OUT4500(ai, EVINTEN, 0);
 }
 
 static void mpi_receive_802_3(struct airo_info *ai)
@@ -3660,7 +3677,7 @@ static void mpi_receive_802_3(struct airo_info *ai)
 			ai->dev->stats.rx_dropped++;
 			goto badrx;
 		}
-		buffer = skb_put(skb,len);
+		buffer = skb_put(skb, len);
 		memcpy(buffer, ai->rxfids[0].virtual_host_addr, ETH_ALEN * 2);
 		if (ai->micstats.enabled) {
 			memcpy(&micbuf,
@@ -3739,8 +3756,8 @@ static void mpi_receive_802_11(struct airo_info *ai)
 	fc = get_unaligned((__le16 *)ptr);
 	hdrlen = header_len(fc);
 
-	skb = dev_alloc_skb( len + hdrlen + 2 );
-	if ( !skb ) {
+	skb = dev_alloc_skb(len + hdrlen + 2);
+	if (!skb) {
 		ai->dev->stats.rx_dropped++;
 		goto badrx;
 	}
@@ -3784,7 +3801,7 @@ static void mpi_receive_802_11(struct airo_info *ai)
 	skb->dev = ai->wifidev;
 	skb->protocol = htons(ETH_P_802_2);
 	skb->ip_summed = CHECKSUM_NONE;
-	netif_rx( skb );
+	netif_rx(skb);
 
 badrx:
 	if (rxd.valid == 0) {
@@ -3815,7 +3832,7 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 	WepKeyRid wkr;
 	int rc;
 
-	memset( &mySsid, 0, sizeof( mySsid ) );
+	memset(&mySsid, 0, sizeof(mySsid));
 	kfree (ai->flash);
 	ai->flash = NULL;
 
@@ -3824,12 +3841,12 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 	cmd.parm0 = cmd.parm1 = cmd.parm2 = 0;
 	if (lock && down_interruptible(&ai->sem))
 		return ERROR;
-	if ( issuecommand( ai, &cmd, &rsp ) != SUCCESS ) {
+	if (issuecommand(ai, &cmd, &rsp) != SUCCESS) {
 		if (lock)
 			up(&ai->sem);
 		return ERROR;
 	}
-	disable_MAC( ai, 0);
+	disable_MAC(ai, 0);
 
 	// Let's figure out if we need to use the AUX port
 	if (!test_bit(FLAG_MPI,&ai->flags)) {
@@ -3859,13 +3876,13 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 		ai->SSID = NULL;
 		// general configuration (read/modify/write)
 		status = readConfigRid(ai, lock);
-		if ( status != SUCCESS ) return ERROR;
+		if (status != SUCCESS) return ERROR;
 
 		status = readCapabilityRid(ai, &cap_rid, lock);
-		if ( status != SUCCESS ) return ERROR;
+		if (status != SUCCESS) return ERROR;
 
-		status = PC4500_readrid(ai,RID_RSSI,&rssi_rid,sizeof(rssi_rid),lock);
-		if ( status == SUCCESS ) {
+		status = PC4500_readrid(ai, RID_RSSI,&rssi_rid, sizeof(rssi_rid), lock);
+		if (status == SUCCESS) {
 			if (ai->rssi || (ai->rssi = kmalloc(512, GFP_KERNEL)) != NULL)
 				memcpy(ai->rssi, (u8*)&rssi_rid + 2, 512); /* Skip RID length member */
 		}
@@ -3890,15 +3907,15 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 		}
 
 		/* Save off the MAC */
-		for( i = 0; i < ETH_ALEN; i++ ) {
+		for (i = 0; i < ETH_ALEN; i++) {
 			mac[i] = ai->config.macAddr[i];
 		}
 
 		/* Check to see if there are any insmod configured
 		   rates to add */
-		if ( rates[0] ) {
-			memset(ai->config.rates,0,sizeof(ai->config.rates));
-			for( i = 0; i < 8 && rates[i]; i++ ) {
+		if (rates[0]) {
+			memset(ai->config.rates, 0, sizeof(ai->config.rates));
+			for (i = 0; i < 8 && rates[i]; i++) {
 				ai->config.rates[i] = rates[i];
 			}
 		}
@@ -3906,9 +3923,9 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 	}
 
 	/* Setup the SSIDs if present */
-	if ( ssids[0] ) {
+	if (ssids[0]) {
 		int i;
-		for( i = 0; i < 3 && ssids[i]; i++ ) {
+		for (i = 0; i < 3 && ssids[i]; i++) {
 			size_t len = strlen(ssids[i]);
 			if (len > 32)
 				len = 32;
@@ -3919,12 +3936,12 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 	}
 
 	status = writeConfigRid(ai, lock);
-	if ( status != SUCCESS ) return ERROR;
+	if (status != SUCCESS) return ERROR;
 
 	/* Set up the SSID list */
-	if ( ssids[0] ) {
+	if (ssids[0]) {
 		status = writeSsidRid(ai, &mySsid, lock);
-		if ( status != SUCCESS ) return ERROR;
+		if (status != SUCCESS) return ERROR;
 	}
 
 	status = enable_MAC(ai, lock);
@@ -3939,14 +3956,15 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 			ai->defindex = wkr.mac[0];
 		}
 		rc = readWepKeyRid(ai, &wkr, 0, lock);
-	} while(lastindex != wkr.kindex);
+	} while (lastindex != wkr.kindex);
 
 	try_auto_wep(ai);
 
 	return SUCCESS;
 }
 
-static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp) {
+static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp)
+{
         // Im really paranoid about letting it run forever!
 	int max_tries = 600000;
 
@@ -3966,7 +3984,7 @@ static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp) {
 			schedule();
 	}
 
-	if ( max_tries == -1 ) {
+	if (max_tries == -1) {
 		airo_print_err(ai->dev->name,
 			"Max tries exceeded when issuing command");
 		if (IN4500(ai, COMMAND) & COMMAND_BUSY)
@@ -3998,7 +4016,7 @@ static u16 issuecommand(struct airo_info *ai, Cmd *pCmd, Resp *pRsp) {
 /* Sets up the bap to start exchange data.  whichbap should
  * be one of the BAP0 or BAP1 defines.  Locks should be held before
  * calling! */
-static int bap_setup(struct airo_info *ai, u16 rid, u16 offset, int whichbap )
+static int bap_setup(struct airo_info *ai, u16 rid, u16 offset, int whichbap)
 {
 	int timeout = 50;
 	int max_tries = 3;
@@ -4013,15 +4031,15 @@ static int bap_setup(struct airo_info *ai, u16 rid, u16 offset, int whichbap )
 			if (timeout--) {
 				continue;
 			}
-		} else if ( status & BAP_ERR ) {
+		} else if (status & BAP_ERR) {
 			/* invalid rid or offset */
 			airo_print_err(ai->dev->name, "BAP error %x %d",
-				status, whichbap );
+				status, whichbap);
 			return ERROR;
 		} else if (status & BAP_DONE) { // success
 			return SUCCESS;
 		}
-		if ( !(max_tries--) ) {
+		if (!(max_tries--)) {
 			airo_print_err(ai->dev->name,
 				"BAP setup error too many retries\n");
 			return ERROR;
@@ -4067,15 +4085,15 @@ static int aux_bap_read(struct airo_info *ai, __le16 *pu16Dst,
 	next = aux_setup(ai, page, offset, &len);
 	words = (bytelen+1)>>1;
 
-	for (i=0; i<words;) {
+	for (i = 0; i<words;) {
 		int count;
 		count = (len>>1) < (words-i) ? (len>>1) : (words-i);
-		if ( !do8bitIO )
-			insw( ai->dev->base_addr+DATA0+whichbap,
-			      pu16Dst+i,count );
+		if (!do8bitIO)
+			insw(ai->dev->base_addr+DATA0+whichbap,
+			      pu16Dst+i, count);
 		else
-			insb( ai->dev->base_addr+DATA0+whichbap,
-			      pu16Dst+i, count << 1 );
+			insb(ai->dev->base_addr+DATA0+whichbap,
+			      pu16Dst+i, count << 1);
 		i += count;
 		if (i<words) {
 			next = aux_setup(ai, next, 4, &len);
@@ -4091,10 +4109,10 @@ static int fast_bap_read(struct airo_info *ai, __le16 *pu16Dst,
 			 int bytelen, int whichbap)
 {
 	bytelen = (bytelen + 1) & (~1); // round up to even value
-	if ( !do8bitIO )
-		insw( ai->dev->base_addr+DATA0+whichbap, pu16Dst, bytelen>>1 );
+	if (!do8bitIO)
+		insw(ai->dev->base_addr+DATA0+whichbap, pu16Dst, bytelen>>1);
 	else
-		insb( ai->dev->base_addr+DATA0+whichbap, pu16Dst, bytelen );
+		insb(ai->dev->base_addr+DATA0+whichbap, pu16Dst, bytelen);
 	return SUCCESS;
 }
 
@@ -4103,11 +4121,11 @@ static int bap_write(struct airo_info *ai, const __le16 *pu16Src,
 		     int bytelen, int whichbap)
 {
 	bytelen = (bytelen + 1) & (~1); // round up to even value
-	if ( !do8bitIO )
-		outsw( ai->dev->base_addr+DATA0+whichbap,
-		       pu16Src, bytelen>>1 );
+	if (!do8bitIO)
+		outsw(ai->dev->base_addr+DATA0+whichbap,
+		       pu16Src, bytelen>>1);
 	else
-		outsb( ai->dev->base_addr+DATA0+whichbap, pu16Src, bytelen );
+		outsb(ai->dev->base_addr+DATA0+whichbap, pu16Src, bytelen);
 	return SUCCESS;
 }
 
@@ -4122,7 +4140,7 @@ static int PC4500_accessrid(struct airo_info *ai, u16 rid, u16 accmd)
 	cmd.parm0 = rid;
 	status = issuecommand(ai, &cmd, &rsp);
 	if (status != 0) return status;
-	if ( (rsp.status & 0x7F00) != 0) {
+	if ((rsp.status & 0x7F00) != 0) {
 		return (accmd << 8) + (rsp.rsp0 & 0xFF);
 	}
 	return 0;
@@ -4177,10 +4195,10 @@ static int PC4500_readrid(struct airo_info *ai, u16 rid, void *pBuf, int len, in
 		// length for remaining part of rid
 		len = min(len, (int)le16_to_cpu(*(__le16*)pBuf)) - 2;
 
-		if ( len <= 2 ) {
+		if (len <= 2) {
 			airo_print_err(ai->dev->name,
 				"Rid %x has a length of %d which is too short",
-				(int)rid, (int)len );
+				(int)rid, (int)len);
 			rc = ERROR;
 	                goto done;
 		}
@@ -4248,7 +4266,7 @@ static int PC4500_writerid(struct airo_info *ai, u16 rid,
 		}
 	} else {
 		// --- first access so that we can write the rid data
-		if ( (status = PC4500_accessrid(ai, rid, CMD_ACCESS)) != 0) {
+		if ((status = PC4500_accessrid(ai, rid, CMD_ACCESS)) != 0) {
 	                rc = status;
 	                goto done;
 	        }
@@ -4285,7 +4303,7 @@ static u16 transmit_allocate(struct airo_info *ai, int lenPayload, int raw)
 		txFid = ERROR;
 		goto done;
 	}
-	if ( (rsp.status & 0xFF00) != 0) {
+	if ((rsp.status & 0xFF00) != 0) {
 		txFid = ERROR;
 		goto done;
 	}
@@ -4344,9 +4362,9 @@ static int transmit_802_3_packet(struct airo_info *ai, int len, char *pPacket)
 	}
 	len -= ETH_ALEN * 2;
 
-	if (test_bit(FLAG_MIC_CAPABLE, &ai->flags) && ai->micstats.enabled && 
+	if (test_bit(FLAG_MIC_CAPABLE, &ai->flags) && ai->micstats.enabled &&
 	    (ntohs(((__be16 *)pPacket)[6]) != 0x888E)) {
-		if (encapsulate(ai,(etherHead *)pPacket,&pMic,len) != SUCCESS)
+		if (encapsulate(ai, (etherHead *)pPacket,&pMic, len) != SUCCESS)
 			return ERROR;
 		miclen = sizeof(pMic);
 	}
@@ -4356,17 +4374,17 @@ static int transmit_802_3_packet(struct airo_info *ai, int len, char *pPacket)
 	/* The hardware addresses aren't counted as part of the payload, so
 	 * we have to subtract the 12 bytes for the addresses off */
 	payloadLen = cpu_to_le16(len + miclen);
-	bap_write(ai, &payloadLen, sizeof(payloadLen),BAP1);
+	bap_write(ai, &payloadLen, sizeof(payloadLen), BAP1);
 	bap_write(ai, (__le16*)pPacket, sizeof(etherHead), BAP1);
 	if (miclen)
 		bap_write(ai, (__le16*)&pMic, miclen, BAP1);
 	bap_write(ai, (__le16*)(pPacket + sizeof(etherHead)), len, BAP1);
 	// issue the transmit command
-	memset( &cmd, 0, sizeof( cmd ) );
+	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd = CMD_TRANSMIT;
 	cmd.parm0 = txFid;
 	if (issuecommand(ai, &cmd, &rsp) != SUCCESS) return ERROR;
-	if ( (rsp.status & 0xFF00) != 0) return ERROR;
+	if ((rsp.status & 0xFF00) != 0) return ERROR;
 	return SUCCESS;
 }
 
@@ -4395,18 +4413,18 @@ static int transmit_802_11_packet(struct airo_info *ai, int len, char *pPacket)
 	/* The 802.11 header aren't counted as part of the payload, so
 	 * we have to subtract the header bytes off */
 	payloadLen = cpu_to_le16(len-hdrlen);
-	bap_write(ai, &payloadLen, sizeof(payloadLen),BAP1);
+	bap_write(ai, &payloadLen, sizeof(payloadLen), BAP1);
 	if (bap_setup(ai, txFid, 0x0014, BAP1) != SUCCESS) return ERROR;
 	bap_write(ai, (__le16 *)pPacket, hdrlen, BAP1);
 	bap_write(ai, (__le16 *)(tail + (hdrlen - 10)), 38 - hdrlen, BAP1);
 
 	bap_write(ai, (__le16 *)(pPacket + hdrlen), len - hdrlen, BAP1);
 	// issue the transmit command
-	memset( &cmd, 0, sizeof( cmd ) );
+	memset(&cmd, 0, sizeof(cmd));
 	cmd.cmd = CMD_TRANSMIT;
 	cmd.parm0 = txFid;
 	if (issuecommand(ai, &cmd, &rsp) != SUCCESS) return ERROR;
-	if ( (rsp.status & 0xFF00) != 0) return ERROR;
+	if ((rsp.status & 0xFF00) != 0) return ERROR;
 	return SUCCESS;
 }
 
@@ -4415,25 +4433,25 @@ static int transmit_802_11_packet(struct airo_info *ai, int len, char *pPacket)
  *  like!  Feel free to clean it up!
  */
 
-static ssize_t proc_read( struct file *file,
+static ssize_t proc_read(struct file *file,
 			  char __user *buffer,
 			  size_t len,
 			  loff_t *offset);
 
-static ssize_t proc_write( struct file *file,
+static ssize_t proc_write(struct file *file,
 			   const char __user *buffer,
 			   size_t len,
-			   loff_t *offset );
-static int proc_close( struct inode *inode, struct file *file );
-
-static int proc_stats_open( struct inode *inode, struct file *file );
-static int proc_statsdelta_open( struct inode *inode, struct file *file );
-static int proc_status_open( struct inode *inode, struct file *file );
-static int proc_SSID_open( struct inode *inode, struct file *file );
-static int proc_APList_open( struct inode *inode, struct file *file );
-static int proc_BSSList_open( struct inode *inode, struct file *file );
-static int proc_config_open( struct inode *inode, struct file *file );
-static int proc_wepkey_open( struct inode *inode, struct file *file );
+			   loff_t *offset);
+static int proc_close(struct inode *inode, struct file *file);
+
+static int proc_stats_open(struct inode *inode, struct file *file);
+static int proc_statsdelta_open(struct inode *inode, struct file *file);
+static int proc_status_open(struct inode *inode, struct file *file);
+static int proc_SSID_open(struct inode *inode, struct file *file);
+static int proc_APList_open(struct inode *inode, struct file *file);
+static int proc_BSSList_open(struct inode *inode, struct file *file);
+static int proc_config_open(struct inode *inode, struct file *file);
+static int proc_wepkey_open(struct inode *inode, struct file *file);
 
 static const struct proc_ops proc_statsdelta_ops = {
 	.proc_read	= proc_read,
@@ -4508,12 +4526,13 @@ struct proc_data {
 	void (*on_close) (struct inode *, struct file *);
 };
 
-static int setup_proc_entry( struct net_device *dev,
-			     struct airo_info *apriv ) {
+static int setup_proc_entry(struct net_device *dev,
+			     struct airo_info *apriv)
+{
 	struct proc_dir_entry *entry;
 
 	/* First setup the device directory */
-	strcpy(apriv->proc_name,dev->name);
+	strcpy(apriv->proc_name, dev->name);
 	apriv->proc_entry = proc_mkdir_mode(apriv->proc_name, airo_perm,
 					    airo_entry);
 	if (!apriv->proc_entry)
@@ -4582,8 +4601,8 @@ static int setup_proc_entry( struct net_device *dev,
 	return -ENOMEM;
 }
 
-static int takedown_proc_entry( struct net_device *dev,
-				struct airo_info *apriv )
+static int takedown_proc_entry(struct net_device *dev,
+				struct airo_info *apriv)
 {
 	remove_proc_subtree(apriv->proc_name, airo_entry);
 	return 0;
@@ -4601,10 +4620,10 @@ static int takedown_proc_entry( struct net_device *dev,
  *  The read routine is generic, it relies on the preallocated rbuffer
  *  to supply the data.
  */
-static ssize_t proc_read( struct file *file,
+static ssize_t proc_read(struct file *file,
 			  char __user *buffer,
 			  size_t len,
-			  loff_t *offset )
+			  loff_t *offset)
 {
 	struct proc_data *priv = file->private_data;
 
@@ -4619,10 +4638,10 @@ static ssize_t proc_read( struct file *file,
  *  The write routine is generic, it fills in a preallocated rbuffer
  *  to supply the data.
  */
-static ssize_t proc_write( struct file *file,
+static ssize_t proc_write(struct file *file,
 			   const char __user *buffer,
 			   size_t len,
-			   loff_t *offset )
+			   loff_t *offset)
 {
 	ssize_t ret;
 	struct proc_data *priv = file->private_data;
@@ -4648,10 +4667,10 @@ static int proc_status_open(struct inode *inode, struct file *file)
 	u16 mode;
 	int i;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	data = file->private_data;
-	if ((data->rbuffer = kmalloc( 2048, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kmalloc(2048, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
@@ -4671,7 +4690,7 @@ static int proc_status_open(struct inode *inode, struct file *file)
                     mode & 0x100 ? "KEY ": "",
                     mode & 0x200 ? "WEP ": "",
                     mode & 0x8000 ? "ERR ": "");
-	sprintf( data->rbuffer+i, "Mode: %x\n"
+	sprintf(data->rbuffer+i, "Mode: %x\n"
 		 "Signal Strength: %d\n"
 		 "Signal Quality: %d\n"
 		 "SSID: %-.*s\n"
@@ -4701,26 +4720,28 @@ static int proc_status_open(struct inode *inode, struct file *file)
 		 le16_to_cpu(cap_rid.softVer),
 		 le16_to_cpu(cap_rid.softSubVer),
 		 le16_to_cpu(cap_rid.bootBlockVer));
-	data->readlen = strlen( data->rbuffer );
+	data->readlen = strlen(data->rbuffer);
 	return 0;
 }
 
 static int proc_stats_rid_open(struct inode*, struct file*, u16);
-static int proc_statsdelta_open( struct inode *inode,
-				 struct file *file ) {
+static int proc_statsdelta_open(struct inode *inode,
+				 struct file *file)
+{
 	if (file->f_mode&FMODE_WRITE) {
 		return proc_stats_rid_open(inode, file, RID_STATSDELTACLEAR);
 	}
 	return proc_stats_rid_open(inode, file, RID_STATSDELTA);
 }
 
-static int proc_stats_open( struct inode *inode, struct file *file ) {
+static int proc_stats_open(struct inode *inode, struct file *file)
+{
 	return proc_stats_rid_open(inode, file, RID_STATS);
 }
 
-static int proc_stats_rid_open( struct inode *inode,
+static int proc_stats_rid_open(struct inode *inode,
 				struct file *file,
-				u16 rid )
+				u16 rid)
 {
 	struct proc_data *data;
 	struct net_device *dev = PDE_DATA(inode);
@@ -4730,10 +4751,10 @@ static int proc_stats_rid_open( struct inode *inode,
 	__le32 *vals = stats.vals;
 	int len;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	data = file->private_data;
-	if ((data->rbuffer = kmalloc( 4096, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kmalloc(4096, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
@@ -4742,7 +4763,7 @@ static int proc_stats_rid_open( struct inode *inode,
 	len = le16_to_cpu(stats.len);
 
         j = 0;
-	for(i=0; statsLabels[i]!=(char *)-1 && i*4<len; i++) {
+	for (i = 0; statsLabels[i]!=(char *)-1 && i*4<len; i++) {
 		if (!statsLabels[i]) continue;
 		if (j+strlen(statsLabels[i])+16>4096) {
 			airo_print_warn(apriv->dev->name,
@@ -4759,7 +4780,8 @@ static int proc_stats_rid_open( struct inode *inode,
 	return 0;
 }
 
-static int get_dec_u16( char *buffer, int *start, int limit ) {
+static int get_dec_u16(char *buffer, int *start, int limit)
+{
 	u16 value;
 	int valid = 0;
 	for (value = 0; *start < limit && buffer[*start] >= '0' &&
@@ -4768,7 +4790,7 @@ static int get_dec_u16( char *buffer, int *start, int limit ) {
 		value *= 10;
 		value += buffer[*start] - '0';
 	}
-	if ( !valid ) return -1;
+	if (!valid) return -1;
 	return value;
 }
 
@@ -4789,15 +4811,15 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 	struct airo_info *ai = dev->ml_priv;
 	char *line;
 
-	if ( !data->writelen ) return;
+	if (!data->writelen) return;
 
 	readConfigRid(ai, 1);
 	set_bit (FLAG_COMMIT, &ai->flags);
 
 	line = data->wbuffer;
-	while( line[0] ) {
+	while (line[0]) {
 /*** Mode processing */
-		if ( !strncmp( line, "Mode: ", 6 ) ) {
+		if (!strncmp(line, "Mode: ", 6)) {
 			line += 6;
 			if (sniffing_mode(ai))
 				set_bit (FLAG_RESET, &ai->flags);
@@ -4805,19 +4827,19 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			clear_bit (FLAG_802_11, &ai->flags);
 			ai->config.opmode &= ~MODE_CFG_MASK;
 			ai->config.scanMode = SCANMODE_ACTIVE;
-			if ( line[0] == 'a' ) {
+			if (line[0] == 'a') {
 				ai->config.opmode |= MODE_STA_IBSS;
 			} else {
 				ai->config.opmode |= MODE_STA_ESS;
-				if ( line[0] == 'r' ) {
+				if (line[0] == 'r') {
 					ai->config.rmode |= RXMODE_RFMON | RXMODE_DISABLE_802_3_HEADER;
 					ai->config.scanMode = SCANMODE_PASSIVE;
 					set_bit (FLAG_802_11, &ai->flags);
-				} else if ( line[0] == 'y' ) {
+				} else if (line[0] == 'y') {
 					ai->config.rmode |= RXMODE_RFMON_ANYBSS | RXMODE_DISABLE_802_3_HEADER;
 					ai->config.scanMode = SCANMODE_PASSIVE;
 					set_bit (FLAG_802_11, &ai->flags);
-				} else if ( line[0] == 'l' )
+				} else if (line[0] == 'l')
 					ai->config.rmode |= RXMODE_LANMON;
 			}
 			set_bit (FLAG_COMMIT, &ai->flags);
@@ -4826,68 +4848,68 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 /*** Radio status */
 		else if (!strncmp(line,"Radio: ", 7)) {
 			line += 7;
-			if (!strncmp(line,"off",3)) {
+			if (!strncmp(line,"off", 3)) {
 				set_bit (FLAG_RADIO_OFF, &ai->flags);
 			} else {
 				clear_bit (FLAG_RADIO_OFF, &ai->flags);
 			}
 		}
 /*** NodeName processing */
-		else if ( !strncmp( line, "NodeName: ", 10 ) ) {
+		else if (!strncmp(line, "NodeName: ", 10)) {
 			int j;
 
 			line += 10;
-			memset( ai->config.nodeName, 0, 16 );
+			memset(ai->config.nodeName, 0, 16);
 /* Do the name, assume a space between the mode and node name */
-			for( j = 0; j < 16 && line[j] != '\n'; j++ ) {
+			for (j = 0; j < 16 && line[j] != '\n'; j++) {
 				ai->config.nodeName[j] = line[j];
 			}
 			set_bit (FLAG_COMMIT, &ai->flags);
 		}
 
 /*** PowerMode processing */
-		else if ( !strncmp( line, "PowerMode: ", 11 ) ) {
+		else if (!strncmp(line, "PowerMode: ", 11)) {
 			line += 11;
-			if ( !strncmp( line, "PSPCAM", 6 ) ) {
+			if (!strncmp(line, "PSPCAM", 6)) {
 				ai->config.powerSaveMode = POWERSAVE_PSPCAM;
 				set_bit (FLAG_COMMIT, &ai->flags);
-			} else if ( !strncmp( line, "PSP", 3 ) ) {
+			} else if (!strncmp(line, "PSP", 3)) {
 				ai->config.powerSaveMode = POWERSAVE_PSP;
 				set_bit (FLAG_COMMIT, &ai->flags);
 			} else {
 				ai->config.powerSaveMode = POWERSAVE_CAM;
 				set_bit (FLAG_COMMIT, &ai->flags);
 			}
-		} else if ( !strncmp( line, "DataRates: ", 11 ) ) {
+		} else if (!strncmp(line, "DataRates: ", 11)) {
 			int v, i = 0, k = 0; /* i is index into line,
 						k is index to rates */
 
 			line += 11;
-			while((v = get_dec_u16(line, &i, 3))!=-1) {
+			while ((v = get_dec_u16(line, &i, 3))!=-1) {
 				ai->config.rates[k++] = (u8)v;
 				line += i + 1;
 				i = 0;
 			}
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "Channel: ", 9 ) ) {
+		} else if (!strncmp(line, "Channel: ", 9)) {
 			int v, i = 0;
 			line += 9;
 			v = get_dec_u16(line, &i, i+3);
-			if ( v != -1 ) {
+			if (v != -1) {
 				ai->config.channelSet = cpu_to_le16(v);
 				set_bit (FLAG_COMMIT, &ai->flags);
 			}
-		} else if ( !strncmp( line, "XmitPower: ", 11 ) ) {
+		} else if (!strncmp(line, "XmitPower: ", 11)) {
 			int v, i = 0;
 			line += 11;
 			v = get_dec_u16(line, &i, i+3);
-			if ( v != -1 ) {
+			if (v != -1) {
 				ai->config.txPower = cpu_to_le16(v);
 				set_bit (FLAG_COMMIT, &ai->flags);
 			}
-		} else if ( !strncmp( line, "WEP: ", 5 ) ) {
+		} else if (!strncmp(line, "WEP: ", 5)) {
 			line += 5;
-			switch( line[0] ) {
+			switch(line[0]) {
 			case 's':
 				set_auth_type(ai, AUTH_SHAREDKEY);
 				break;
@@ -4899,7 +4921,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 				break;
 			}
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "LongRetryLimit: ", 16 ) ) {
+		} else if (!strncmp(line, "LongRetryLimit: ", 16)) {
 			int v, i = 0;
 
 			line += 16;
@@ -4907,7 +4929,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : ((v>255) ? 255 : v);
 			ai->config.longRetryLimit = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "ShortRetryLimit: ", 17 ) ) {
+		} else if (!strncmp(line, "ShortRetryLimit: ", 17)) {
 			int v, i = 0;
 
 			line += 17;
@@ -4915,7 +4937,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : ((v>255) ? 255 : v);
 			ai->config.shortRetryLimit = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "RTSThreshold: ", 14 ) ) {
+		} else if (!strncmp(line, "RTSThreshold: ", 14)) {
 			int v, i = 0;
 
 			line += 14;
@@ -4923,7 +4945,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : ((v>AIRO_DEF_MTU) ? AIRO_DEF_MTU : v);
 			ai->config.rtsThres = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "TXMSDULifetime: ", 16 ) ) {
+		} else if (!strncmp(line, "TXMSDULifetime: ", 16)) {
 			int v, i = 0;
 
 			line += 16;
@@ -4931,7 +4953,7 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : v;
 			ai->config.txLifetime = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "RXMSDULifetime: ", 16 ) ) {
+		} else if (!strncmp(line, "RXMSDULifetime: ", 16)) {
 			int v, i = 0;
 
 			line += 16;
@@ -4939,17 +4961,17 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 			v = (v<0) ? 0 : v;
 			ai->config.rxLifetime = cpu_to_le16(v);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "TXDiversity: ", 13 ) ) {
+		} else if (!strncmp(line, "TXDiversity: ", 13)) {
 			ai->config.txDiversity =
 				(line[13]=='l') ? 1 :
 				((line[13]=='r')? 2: 3);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "RXDiversity: ", 13 ) ) {
+		} else if (!strncmp(line, "RXDiversity: ", 13)) {
 			ai->config.rxDiversity =
 				(line[13]=='l') ? 1 :
 				((line[13]=='r')? 2: 3);
 			set_bit (FLAG_COMMIT, &ai->flags);
-		} else if ( !strncmp( line, "FragThreshold: ", 15 ) ) {
+		} else if (!strncmp(line, "FragThreshold: ", 15)) {
 			int v, i = 0;
 
 			line += 15;
@@ -4961,24 +4983,24 @@ static void proc_config_on_close(struct inode *inode, struct file *file)
 		} else if (!strncmp(line, "Modulation: ", 12)) {
 			line += 12;
 			switch(*line) {
-			case 'd':  ai->config.modulation=MOD_DEFAULT; set_bit(FLAG_COMMIT, &ai->flags); break;
-			case 'c':  ai->config.modulation=MOD_CCK; set_bit(FLAG_COMMIT, &ai->flags); break;
-			case 'm':  ai->config.modulation=MOD_MOK; set_bit(FLAG_COMMIT, &ai->flags); break;
+			case 'd':  ai->config.modulation = MOD_DEFAULT; set_bit(FLAG_COMMIT, &ai->flags); break;
+			case 'c':  ai->config.modulation = MOD_CCK; set_bit(FLAG_COMMIT, &ai->flags); break;
+			case 'm':  ai->config.modulation = MOD_MOK; set_bit(FLAG_COMMIT, &ai->flags); break;
 			default: airo_print_warn(ai->dev->name, "Unknown modulation");
 			}
 		} else if (!strncmp(line, "Preamble: ", 10)) {
 			line += 10;
 			switch(*line) {
-			case 'a': ai->config.preamble=PREAMBLE_AUTO; set_bit(FLAG_COMMIT, &ai->flags); break;
-			case 'l': ai->config.preamble=PREAMBLE_LONG; set_bit(FLAG_COMMIT, &ai->flags); break;
-			case 's': ai->config.preamble=PREAMBLE_SHORT; set_bit(FLAG_COMMIT, &ai->flags); break;
+			case 'a': ai->config.preamble = PREAMBLE_AUTO; set_bit(FLAG_COMMIT, &ai->flags); break;
+			case 'l': ai->config.preamble = PREAMBLE_LONG; set_bit(FLAG_COMMIT, &ai->flags); break;
+			case 's': ai->config.preamble = PREAMBLE_SHORT; set_bit(FLAG_COMMIT, &ai->flags); break;
 			default: airo_print_warn(ai->dev->name, "Unknown preamble");
 			}
 		} else {
 			airo_print_warn(ai->dev->name, "Couldn't figure out %s", line);
 		}
-		while( line[0] && line[0] != '\n' ) line++;
-		if ( line[0] ) line++;
+		while (line[0] && line[0] != '\n') line++;
+		if (line[0]) line++;
 	}
 	airo_config_commit(dev, NULL, NULL, NULL);
 }
@@ -5001,14 +5023,14 @@ static int proc_config_open(struct inode *inode, struct file *file)
 	int i;
 	__le16 mode;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	data = file->private_data;
-	if ((data->rbuffer = kmalloc( 2048, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kmalloc(2048, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
-	if ((data->wbuffer = kzalloc( 2048, GFP_KERNEL )) == NULL) {
+	if ((data->wbuffer = kzalloc(2048, GFP_KERNEL)) == NULL) {
 		kfree (data->rbuffer);
 		kfree (file->private_data);
 		return -ENOMEM;
@@ -5019,7 +5041,7 @@ static int proc_config_open(struct inode *inode, struct file *file)
 	readConfigRid(ai, 1);
 
 	mode = ai->config.opmode & MODE_CFG_MASK;
-	i = sprintf( data->rbuffer,
+	i = sprintf(data->rbuffer,
 		     "Mode: %s\n"
 		     "Radio: %s\n"
 		     "NodeName: %-16s\n"
@@ -5048,7 +5070,7 @@ static int proc_config_open(struct inode *inode, struct file *file)
 		     le16_to_cpu(ai->config.channelSet),
 		     le16_to_cpu(ai->config.txPower)
 		);
-	sprintf( data->rbuffer + i,
+	sprintf(data->rbuffer + i,
 		 "LongRetryLimit: %d\n"
 		 "ShortRetryLimit: %d\n"
 		 "RTSThreshold: %d\n"
@@ -5079,7 +5101,7 @@ static int proc_config_open(struct inode *inode, struct file *file)
 		 ai->config.preamble == PREAMBLE_LONG ? "long" :
 		 ai->config.preamble == PREAMBLE_SHORT ? "short" : "error"
 		);
-	data->readlen = strlen( data->rbuffer );
+	data->readlen = strlen(data->rbuffer);
 	return 0;
 }
 
@@ -5119,14 +5141,15 @@ static void proc_SSID_on_close(struct inode *inode, struct file *file)
 	enable_MAC(ai, 1);
 }
 
-static void proc_APList_on_close( struct inode *inode, struct file *file ) {
+static void proc_APList_on_close(struct inode *inode, struct file *file)
+{
 	struct proc_data *data = file->private_data;
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
 	APListRid *APList_rid = &ai->APList;
 	int i;
 
-	if ( !data->writelen ) return;
+	if (!data->writelen) return;
 
 	memset(APList_rid, 0, sizeof(*APList_rid));
 	APList_rid->len = cpu_to_le16(sizeof(*APList_rid));
@@ -5140,8 +5163,9 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 }
 
 /* This function wraps PC4500_writerid with a MAC disable */
-static int do_writerid( struct airo_info *ai, u16 rid, const void *rid_data,
-			int len, int dummy ) {
+static int do_writerid(struct airo_info *ai, u16 rid, const void *rid_data,
+			int len, int dummy)
+{
 	int rc;
 
 	disable_MAC(ai, 1);
@@ -5241,7 +5265,8 @@ static int set_wep_tx_idx(struct airo_info *ai, u16 index, int perm, int lock)
 	return rc;
 }
 
-static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
+static void proc_wepkey_on_close(struct inode *inode, struct file *file)
+{
 	struct proc_data *data;
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
@@ -5253,7 +5278,7 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 	memset(key, 0, sizeof(key));
 
 	data = file->private_data;
-	if ( !data->writelen ) return;
+	if (!data->writelen) return;
 
 	if (data->wbuffer[0] >= '0' && data->wbuffer[0] <= '3' &&
 	    (data->wbuffer[1] == ' ' || data->wbuffer[1] == '\n')) {
@@ -5273,7 +5298,7 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 		return;
 	}
 
-	for( i = 0; i < 16*3 && data->wbuffer[i+j]; i++ ) {
+	for (i = 0; i < 16*3 && data->wbuffer[i+j]; i++) {
 		switch(i%3) {
 		case 0:
 			key[i/3] = hex_to_bin(data->wbuffer[i+j])<<4;
@@ -5291,7 +5316,7 @@ static void proc_wepkey_on_close( struct inode *inode, struct file *file ) {
 	}
 }
 
-static int proc_wepkey_open( struct inode *inode, struct file *file )
+static int proc_wepkey_open(struct inode *inode, struct file *file)
 {
 	struct proc_data *data;
 	struct net_device *dev = PDE_DATA(inode);
@@ -5299,20 +5324,20 @@ static int proc_wepkey_open( struct inode *inode, struct file *file )
 	char *ptr;
 	WepKeyRid wkr;
 	__le16 lastindex;
-	int j=0;
+	int j = 0;
 	int rc;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	memset(&wkr, 0, sizeof(wkr));
 	data = file->private_data;
-	if ((data->rbuffer = kzalloc( 180, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kzalloc(180, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
 	data->writelen = 0;
 	data->maxwritelen = 80;
-	if ((data->wbuffer = kzalloc( 80, GFP_KERNEL )) == NULL) {
+	if ((data->wbuffer = kzalloc(80, GFP_KERNEL)) == NULL) {
 		kfree (data->rbuffer);
 		kfree (file->private_data);
 		return -ENOMEM;
@@ -5333,9 +5358,9 @@ static int proc_wepkey_open( struct inode *inode, struct file *file )
 				     le16_to_cpu(wkr.klen));
 		}
 		readWepKeyRid(ai, &wkr, 0, 1);
-	} while((lastindex != wkr.kindex) && (j < 180-30));
+	} while ((lastindex != wkr.kindex) && (j < 180-30));
 
-	data->readlen = strlen( data->rbuffer );
+	data->readlen = strlen(data->rbuffer);
 	return 0;
 }
 
@@ -5348,10 +5373,10 @@ static int proc_SSID_open(struct inode *inode, struct file *file)
 	char *ptr;
 	SsidRid SSID_rid;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	data = file->private_data;
-	if ((data->rbuffer = kmalloc( 104, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kmalloc(104, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
@@ -5379,11 +5404,12 @@ static int proc_SSID_open(struct inode *inode, struct file *file)
 		*ptr++ = '\n';
 	}
 	*ptr = '\0';
-	data->readlen = strlen( data->rbuffer );
+	data->readlen = strlen(data->rbuffer);
 	return 0;
 }
 
-static int proc_APList_open( struct inode *inode, struct file *file ) {
+static int proc_APList_open(struct inode *inode, struct file *file)
+{
 	struct proc_data *data;
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
@@ -5391,16 +5417,16 @@ static int proc_APList_open( struct inode *inode, struct file *file ) {
 	char *ptr;
 	APListRid *APList_rid = &ai->APList;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	data = file->private_data;
-	if ((data->rbuffer = kmalloc( 104, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kmalloc(104, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
 	data->writelen = 0;
 	data->maxwritelen = 4*6*3;
-	if ((data->wbuffer = kzalloc( data->maxwritelen, GFP_KERNEL )) == NULL) {
+	if ((data->wbuffer = kzalloc(data->maxwritelen, GFP_KERNEL)) == NULL) {
 		kfree (data->rbuffer);
 		kfree (file->private_data);
 		return -ENOMEM;
@@ -5408,20 +5434,21 @@ static int proc_APList_open( struct inode *inode, struct file *file ) {
 	data->on_close = proc_APList_on_close;
 
 	ptr = data->rbuffer;
-	for( i = 0; i < 4; i++ ) {
+	for (i = 0; i < 4; i++) {
 // We end when we find a zero MAC
-		if ( !*(int*)APList_rid->ap[i] &&
+		if (!*(int*)APList_rid->ap[i] &&
 		     !*(int*)&APList_rid->ap[i][2]) break;
 		ptr += sprintf(ptr, "%pM\n", APList_rid->ap[i]);
 	}
 	if (i==0) ptr += sprintf(ptr, "Not using specific APs\n");
 
 	*ptr = '\0';
-	data->readlen = strlen( data->rbuffer );
+	data->readlen = strlen(data->rbuffer);
 	return 0;
 }
 
-static int proc_BSSList_open( struct inode *inode, struct file *file ) {
+static int proc_BSSList_open(struct inode *inode, struct file *file)
+{
 	struct proc_data *data;
 	struct net_device *dev = PDE_DATA(inode);
 	struct airo_info *ai = dev->ml_priv;
@@ -5431,10 +5458,10 @@ static int proc_BSSList_open( struct inode *inode, struct file *file ) {
 	/* If doLoseSync is not 1, we won't do a Lose Sync */
 	int doLoseSync = -1;
 
-	if ((file->private_data = kzalloc(sizeof(struct proc_data ), GFP_KERNEL)) == NULL)
+	if ((file->private_data = kzalloc(sizeof(struct proc_data), GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 	data = file->private_data;
-	if ((data->rbuffer = kmalloc( 1024, GFP_KERNEL )) == NULL) {
+	if ((data->rbuffer = kmalloc(1024, GFP_KERNEL)) == NULL) {
 		kfree (file->private_data);
 		return -ENOMEM;
 	}
@@ -5454,7 +5481,7 @@ static int proc_BSSList_open( struct inode *inode, struct file *file ) {
 				return -ENETDOWN;
 			}
 			memset(&cmd, 0, sizeof(cmd));
-			cmd.cmd=CMD_LISTBSS;
+			cmd.cmd = CMD_LISTBSS;
 			if (down_interruptible(&ai->sem)) {
 				kfree(data->rbuffer);
 				kfree(file->private_data);
@@ -5472,7 +5499,7 @@ static int proc_BSSList_open( struct inode *inode, struct file *file ) {
            Since it is a rare condition, we'll just live with it, otherwise
            we have to add a spin lock... */
 	rc = readBSSListRid(ai, doLoseSync, &BSSList_rid);
-	while(rc == 0 && BSSList_rid.index != cpu_to_le16(0xffff)) {
+	while (rc == 0 && BSSList_rid.index != cpu_to_le16(0xffff)) {
 		ptr += sprintf(ptr, "%pM %.*s rssi = %d",
 			       BSSList_rid.bssid,
 				(int)BSSList_rid.ssidLen,
@@ -5487,11 +5514,11 @@ static int proc_BSSList_open( struct inode *inode, struct file *file ) {
 		rc = readBSSListRid(ai, 0, &BSSList_rid);
 	}
 	*ptr = '\0';
-	data->readlen = strlen( data->rbuffer );
+	data->readlen = strlen(data->rbuffer);
 	return 0;
 }
 
-static int proc_close( struct inode *inode, struct file *file )
+static int proc_close(struct inode *inode, struct file *file)
 {
 	struct proc_data *data = file->private_data;
 
@@ -5508,7 +5535,8 @@ static int proc_close( struct inode *inode, struct file *file )
    will switch WEP modes to see if that will help.  If the card is
    associated we will check every minute to see if anything has
    changed. */
-static void timer_func( struct net_device *dev ) {
+static void timer_func(struct net_device *dev)
+{
 	struct airo_info *apriv = dev->ml_priv;
 
 /* We don't have a link so try changing the authtype */
@@ -5642,7 +5670,7 @@ static int __maybe_unused airo_pci_resume(struct device *dev_d)
 }
 #endif
 
-static int __init airo_init_module( void )
+static int __init airo_init_module(void)
 {
 	int i;
 
@@ -5658,8 +5686,8 @@ static int __init airo_init_module( void )
 
 	for (i = 0; i < 4 && io[i] && irq[i]; i++) {
 		airo_print_info("", "Trying to configure ISA adapter at irq=%d "
-			"io=0x%x", irq[i], io[i] );
-		if (init_airo_card( irq[i], io[i], 0, NULL )) {
+			"io = 0x%x", irq[i], io[i]);
+		if (init_airo_card(irq[i], io[i], 0, NULL)) {
 			/* do nothing */ ;
 		}
 	}
@@ -5681,10 +5709,10 @@ static int __init airo_init_module( void )
 	return 0;
 }
 
-static void __exit airo_cleanup_module( void )
+static void __exit airo_cleanup_module(void)
 {
 	struct airo_info *ai;
-	while(!list_empty(&airo_devices)) {
+	while (!list_empty(&airo_devices)) {
 		ai = list_entry(airo_devices.next, struct airo_info, dev_list);
 		airo_print_info(ai->dev->name, "Unregistering...");
 		stop_airo_card(ai->dev, 1);
@@ -5784,7 +5812,7 @@ static int airo_set_freq(struct net_device *dev,
 	int rc = -EINPROGRESS;		/* Call commit handler */
 
 	/* If setting by frequency, convert to a channel */
-	if(fwrq->e == 1) {
+	if (fwrq->e == 1) {
 		int f = fwrq->m / 100000;
 
 		/* Hack to fall through... */
@@ -5798,7 +5826,7 @@ static int airo_set_freq(struct net_device *dev,
 		int channel = fwrq->m;
 		/* We should do a better check than that,
 		 * based on the card capability !!! */
-		if((channel < 1) || (channel > 14)) {
+		if ((channel < 1) || (channel > 14)) {
 			airo_print_dbg(dev->name, "New channel value of %d is invalid!",
 				fwrq->m);
 			rc = -EINVAL;
@@ -5832,7 +5860,7 @@ static int airo_get_freq(struct net_device *dev,
 		readStatusRid(local, &status_rid, 1);
 
 	ch = le16_to_cpu(status_rid.channel);
-	if((ch > 0) && (ch < 15)) {
+	if ((ch > 0) && (ch < 15)) {
 		fwrq->m = 100000 *
 			ieee80211_channel_to_frequency(ch, NL80211_BAND_2GHZ);
 		fwrq->e = 1;
@@ -5936,7 +5964,7 @@ static int airo_set_wap(struct net_device *dev,
 	else if (is_broadcast_ether_addr(awrq->sa_data) ||
 		 is_zero_ether_addr(awrq->sa_data)) {
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.cmd=CMD_LOSE_SYNC;
+		cmd.cmd = CMD_LOSE_SYNC;
 		if (down_interruptible(&local->sem))
 			return -ERESTARTSYS;
 		issuecommand(local, &cmd, &rsp);
@@ -5985,7 +6013,7 @@ static int airo_set_nick(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 
 	/* Check the size of the string */
-	if(dwrq->length > 16) {
+	if (dwrq->length > 16) {
 		return -E2BIG;
 	}
 	readConfigRid(local, 1);
@@ -6033,7 +6061,7 @@ static int airo_set_rate(struct net_device *dev,
 	readCapabilityRid(local, &cap_rid, 1);
 
 	/* Which type of value ? */
-	if((vwrq->value < 8) && (vwrq->value >= 0)) {
+	if ((vwrq->value < 8) && (vwrq->value >= 0)) {
 		/* Setting by rate index */
 		/* Find value in the magic rate table */
 		brate = cap_rid.supportedRates[vwrq->value];
@@ -6042,36 +6070,36 @@ static int airo_set_rate(struct net_device *dev,
 		u8	normvalue = (u8) (vwrq->value/500000);
 
 		/* Check if rate is valid */
-		for(i = 0 ; i < 8 ; i++) {
-			if(normvalue == cap_rid.supportedRates[i]) {
+		for (i = 0 ; i < 8 ; i++) {
+			if (normvalue == cap_rid.supportedRates[i]) {
 				brate = normvalue;
 				break;
 			}
 		}
 	}
 	/* -1 designed the max rate (mostly auto mode) */
-	if(vwrq->value == -1) {
+	if (vwrq->value == -1) {
 		/* Get the highest available rate */
-		for(i = 0 ; i < 8 ; i++) {
-			if(cap_rid.supportedRates[i] == 0)
+		for (i = 0 ; i < 8 ; i++) {
+			if (cap_rid.supportedRates[i] == 0)
 				break;
 		}
-		if(i != 0)
+		if (i != 0)
 			brate = cap_rid.supportedRates[i - 1];
 	}
 	/* Check that it is valid */
-	if(brate == 0) {
+	if (brate == 0) {
 		return -EINVAL;
 	}
 
 	readConfigRid(local, 1);
 	/* Now, check if we want a fixed or auto value */
-	if(vwrq->fixed == 0) {
+	if (vwrq->fixed == 0) {
 		/* Fill all the rates up to this max rate */
 		memset(local->config.rates, 0, 8);
-		for(i = 0 ; i < 8 ; i++) {
+		for (i = 0 ; i < 8 ; i++) {
 			local->config.rates[i] = cap_rid.supportedRates[i];
-			if(local->config.rates[i] == brate)
+			if (local->config.rates[i] == brate)
 				break;
 		}
 	} else {
@@ -6119,9 +6147,9 @@ static int airo_set_rts(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	int rthr = vwrq->value;
 
-	if(vwrq->disabled)
+	if (vwrq->disabled)
 		rthr = AIRO_DEF_MTU;
-	if((rthr < 0) || (rthr > AIRO_DEF_MTU)) {
+	if ((rthr < 0) || (rthr > AIRO_DEF_MTU)) {
 		return -EINVAL;
 	}
 	readConfigRid(local, 1);
@@ -6162,9 +6190,9 @@ static int airo_set_frag(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	int fthr = vwrq->value;
 
-	if(vwrq->disabled)
+	if (vwrq->disabled)
 		fthr = AIRO_DEF_MTU;
-	if((fthr < 256) || (fthr > AIRO_DEF_MTU)) {
+	if ((fthr < 256) || (fthr > AIRO_DEF_MTU)) {
 		return -EINVAL;
 	}
 	fthr &= ~0x1;	/* Get an even value - is it really needed ??? */
@@ -6341,7 +6369,7 @@ static int airo_set_encode(struct net_device *dev,
 		else
 			key.len = MIN_KEY_SIZE;
 		/* Check if the key is not marked as invalid */
-		if(!(dwrq->flags & IW_ENCODE_NOKEY)) {
+		if (!(dwrq->flags & IW_ENCODE_NOKEY)) {
 			/* Cleanup */
 			memset(key.key, 0, MAX_KEY_SIZE);
 			/* Copy the key in the driver */
@@ -6358,7 +6386,7 @@ static int airo_set_encode(struct net_device *dev,
 		/* WE specify that if a valid key is set, encryption
 		 * should be enabled (user may turn it off later)
 		 * This is also how "iwconfig ethX key on" works */
-		if((index == current_index) && (key.len > 0) &&
+		if ((index == current_index) && (key.len > 0) &&
 		   (local->config.authType == AUTH_OPEN))
 			set_auth_type(local, AUTH_ENCRYPT);
 	} else {
@@ -6381,7 +6409,7 @@ static int airo_set_encode(struct net_device *dev,
 	/* Read the flags */
 	if (dwrq->flags & IW_ENCODE_DISABLED)
 		set_auth_type(local, AUTH_OPEN);	/* disable encryption */
-	if(dwrq->flags & IW_ENCODE_RESTRICTED)
+	if (dwrq->flags & IW_ENCODE_RESTRICTED)
 		set_auth_type(local, AUTH_SHAREDKEY);	/* Only Both */
 	if (dwrq->flags & IW_ENCODE_OPEN)
 		set_auth_type(local, AUTH_ENCRYPT);	/* Only Wep */
@@ -6459,7 +6487,7 @@ static int airo_set_encodeext(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	struct iw_point *encoding = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	int perm = ( encoding->flags & IW_ENCODE_TEMP ? 0 : 1 );
+	int perm = (encoding->flags & IW_ENCODE_TEMP ? 0 : 1);
 	__le16 currentAuthType = local->config.authType;
 	int idx, key_len, alg = ext->alg, set_key = 1, rc;
 	wep_key_t key;
@@ -6541,7 +6569,7 @@ static int airo_set_encodeext(struct net_device *dev,
 	/* Read the flags */
 	if (encoding->flags & IW_ENCODE_DISABLED)
 		set_auth_type(local, AUTH_OPEN);	/* disable encryption */
-	if(encoding->flags & IW_ENCODE_RESTRICTED)
+	if (encoding->flags & IW_ENCODE_RESTRICTED)
 		set_auth_type(local, AUTH_SHAREDKEY);	/* Only Both */
 	if (encoding->flags & IW_ENCODE_OPEN)
 		set_auth_type(local, AUTH_ENCRYPT);
@@ -6607,7 +6635,7 @@ static int airo_get_encodeext(struct net_device *dev,
 	/* We can't return the key, so set the proper flag and return zero */
 	encoding->flags |= IW_ENCODE_NOKEY;
 	memset(extra, 0, 16);
-	
+
 	/* Copy the key to the user buffer */
 	wep_key_len = get_wep_key(local, idx, &buf[0], sizeof(buf));
 	if (wep_key_len < 0) {
@@ -6807,13 +6835,13 @@ static int airo_set_retry(struct net_device *dev,
 	struct airo_info *local = dev->ml_priv;
 	int rc = -EINVAL;
 
-	if(vwrq->disabled) {
+	if (vwrq->disabled) {
 		return -EINVAL;
 	}
 	readConfigRid(local, 1);
-	if(vwrq->flags & IW_RETRY_LIMIT) {
+	if (vwrq->flags & IW_RETRY_LIMIT) {
 		__le16 v = cpu_to_le16(vwrq->value);
-		if(vwrq->flags & IW_RETRY_LONG)
+		if (vwrq->flags & IW_RETRY_LONG)
 			local->config.longRetryLimit = v;
 		else if (vwrq->flags & IW_RETRY_SHORT)
 			local->config.shortRetryLimit = v;
@@ -6825,7 +6853,7 @@ static int airo_set_retry(struct net_device *dev,
 		set_bit (FLAG_COMMIT, &local->flags);
 		rc = -EINPROGRESS;		/* Call commit handler */
 	}
-	if(vwrq->flags & IW_RETRY_LIFETIME) {
+	if (vwrq->flags & IW_RETRY_LIFETIME) {
 		local->config.txLifetime = cpu_to_le16(vwrq->value / 1024);
 		set_bit (FLAG_COMMIT, &local->flags);
 		rc = -EINPROGRESS;		/* Call commit handler */
@@ -6848,16 +6876,16 @@ static int airo_get_retry(struct net_device *dev,
 
 	readConfigRid(local, 1);
 	/* Note : by default, display the min retry number */
-	if((vwrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
+	if ((vwrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
 		vwrq->flags = IW_RETRY_LIFETIME;
 		vwrq->value = le16_to_cpu(local->config.txLifetime) * 1024;
-	} else if((vwrq->flags & IW_RETRY_LONG)) {
+	} else if ((vwrq->flags & IW_RETRY_LONG)) {
 		vwrq->flags = IW_RETRY_LIMIT | IW_RETRY_LONG;
 		vwrq->value = le16_to_cpu(local->config.longRetryLimit);
 	} else {
 		vwrq->flags = IW_RETRY_LIMIT;
 		vwrq->value = le16_to_cpu(local->config.shortRetryLimit);
-		if(local->config.shortRetryLimit != local->config.longRetryLimit)
+		if (local->config.shortRetryLimit != local->config.longRetryLimit)
 			vwrq->flags |= IW_RETRY_SHORT;
 	}
 
@@ -6889,7 +6917,7 @@ static int airo_get_range(struct net_device *dev,
 	/* Should be based on cap_rid.country to give only
 	 * what the current card support */
 	k = 0;
-	for(i = 0; i < 14; i++) {
+	for (i = 0; i < 14; i++) {
 		range->freq[k].i = i + 1; /* List index */
 		range->freq[k].m = 100000 *
 		     ieee80211_channel_to_frequency(i + 1, NL80211_BAND_2GHZ);
@@ -6919,9 +6947,9 @@ static int airo_get_range(struct net_device *dev,
 	}
 	range->avg_qual.noise = 0x100 - 85;		/* -85 dBm */
 
-	for(i = 0 ; i < 8 ; i++) {
+	for (i = 0 ; i < 8 ; i++) {
 		range->bitrate[i] = cap_rid.supportedRates[i] * 500000;
-		if(range->bitrate[i] == 0)
+		if (range->bitrate[i] == 0)
 			break;
 	}
 	range->num_bitrates = i;
@@ -6929,7 +6957,7 @@ static int airo_get_range(struct net_device *dev,
 	/* Set an indication of the max TCP throughput
 	 * in bit/s that we can expect using this interface.
 	 * May be use for QoS stuff... Jean II */
-	if(i > 2)
+	if (i > 2)
 		range->throughput = 5000 * 1000;
 	else
 		range->throughput = 1500 * 1000;
@@ -6939,7 +6967,7 @@ static int airo_get_range(struct net_device *dev,
 	range->min_frag = 256;
 	range->max_frag = AIRO_DEF_MTU;
 
-	if(cap_rid.softCap & cpu_to_le16(2)) {
+	if (cap_rid.softCap & cpu_to_le16(2)) {
 		// WEP: RC4 40 bits
 		range->encoding_size[0] = 5;
 		// RC4 ~128 bits
@@ -6963,9 +6991,9 @@ static int airo_get_range(struct net_device *dev,
 	range->pm_capa = IW_POWER_PERIOD | IW_POWER_TIMEOUT | IW_POWER_ALL_R;
 
 	/* Transmit Power - values are in mW */
-	for(i = 0 ; i < 8 ; i++) {
+	for (i = 0 ; i < 8 ; i++) {
 		range->txpower[i] = le16_to_cpu(cap_rid.txPowerLevels[i]);
-		if(range->txpower[i] == 0)
+		if (range->txpower[i] == 0)
 			break;
 	}
 	range->num_txpower = i;
@@ -7236,7 +7264,7 @@ static int airo_set_scan(struct net_device *dev,
 	/* Initiate a scan command */
 	ai->scan_timeout = RUN_AT(3*HZ);
 	memset(&cmd, 0, sizeof(cmd));
-	cmd.cmd=CMD_LISTBSS;
+	cmd.cmd = CMD_LISTBSS;
 	issuecommand(ai, &cmd, &rsp);
 	wake = 1;
 
@@ -7277,7 +7305,7 @@ static inline char *airo_translate_scan(struct net_device *dev,
 
 	/* Add the ESSID */
 	iwe.u.data.length = bss->ssidLen;
-	if(iwe.u.data.length > 32)
+	if (iwe.u.data.length > 32)
 		iwe.u.data.length = 32;
 	iwe.cmd = SIOCGIWESSID;
 	iwe.u.data.flags = 1;
@@ -7287,8 +7315,8 @@ static inline char *airo_translate_scan(struct net_device *dev,
 	/* Add mode */
 	iwe.cmd = SIOCGIWMODE;
 	capabilities = bss->cap;
-	if(capabilities & (CAP_ESS | CAP_IBSS)) {
-		if(capabilities & CAP_ESS)
+	if (capabilities & (CAP_ESS | CAP_IBSS)) {
+		if (capabilities & CAP_ESS)
 			iwe.u.mode = IW_MODE_MASTER;
 		else
 			iwe.u.mode = IW_MODE_ADHOC;
@@ -7328,7 +7356,7 @@ static inline char *airo_translate_scan(struct net_device *dev,
 
 	/* Add encryption capability */
 	iwe.cmd = SIOCGIWENCODE;
-	if(capabilities & CAP_PRIVACY)
+	if (capabilities & CAP_PRIVACY)
 		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
 	else
 		iwe.u.data.flags = IW_ENCODE_DISABLED;
@@ -7344,9 +7372,9 @@ static inline char *airo_translate_scan(struct net_device *dev,
 	/* Those two flags are ignored... */
 	iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
 	/* Max 8 values */
-	for(i = 0 ; i < 8 ; i++) {
+	for (i = 0 ; i < 8 ; i++) {
 		/* NULL terminated */
-		if(bss->rates[i] == 0)
+		if (bss->rates[i] == 0)
 			break;
 		/* Bit rate given in 500 kb/s units (+ 0x80) */
 		iwe.u.bitrate.value = ((bss->rates[i] & 0x7f) * 500000);
@@ -7454,7 +7482,7 @@ static int airo_get_scan(struct net_device *dev,
 						 &net->bss);
 
 		/* Check if there is space for one more entry */
-		if((extra + dwrq->length - current_ev) <= IW_EV_ADDR_LEN) {
+		if ((extra + dwrq->length - current_ev) <= IW_EV_ADDR_LEN) {
 			/* Ask user space to try again with a bigger buffer */
 			err = -E2BIG;
 			goto out;
@@ -7492,7 +7520,7 @@ static int airo_config_commit(struct net_device *dev,
 
 		readSsidRid(local, &SSID_rid);
 		if (test_bit(FLAG_MPI,&local->flags))
-			setup_card(local, dev->dev_addr, 1 );
+			setup_card(local, dev->dev_addr, 1);
 		else
 			reset_airo_card(dev);
 		disable_MAC(local, 1);
@@ -7636,9 +7664,9 @@ static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	{
 		int val = AIROMAGIC;
 		aironet_ioctl com;
-		if (copy_from_user(&com,rq->ifr_data,sizeof(com)))
+		if (copy_from_user(&com, rq->ifr_data, sizeof(com)))
 			rc = -EFAULT;
-		else if (copy_to_user(com.data,(char *)&val,sizeof(val)))
+		else if (copy_to_user(com.data, (char *)&val, sizeof(val)))
 			rc = -EFAULT;
 	}
 	break;
@@ -7652,24 +7680,24 @@ static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		 */
 	{
 		aironet_ioctl com;
-		if (copy_from_user(&com,rq->ifr_data,sizeof(com))) {
+		if (copy_from_user(&com, rq->ifr_data, sizeof(com))) {
 			rc = -EFAULT;
 			break;
 		}
 
 		/* Separate R/W functions bracket legality here
 		 */
-		if ( com.command == AIRORSWVERSION ) {
+		if (com.command == AIRORSWVERSION) {
 			if (copy_to_user(com.data, swversion, sizeof(swversion)))
 				rc = -EFAULT;
 			else
 				rc = 0;
 		}
-		else if ( com.command <= AIRORRID)
+		else if (com.command <= AIRORRID)
 			rc = readrids(dev,&com);
-		else if ( com.command >= AIROPCAP && com.command <= (AIROPLEAPUSR+2) )
+		else if (com.command >= AIROPCAP && com.command <= (AIROPLEAPUSR+2))
 			rc = writerids(dev,&com);
-		else if ( com.command >= AIROFLSHRST && com.command <= AIRORESTART )
+		else if (com.command >= AIROFLSHRST && com.command <= AIRORESTART)
 			rc = flashcard(dev,&com);
 		else
 			rc = -EINVAL;      /* Bad command in ioctl */
@@ -7771,7 +7799,8 @@ static struct iw_statistics *airo_get_wireless_stats(struct net_device *dev)
  * as needed.  This represents the READ side of control I/O to
  * the card
  */
-static int readrids(struct net_device *dev, aironet_ioctl *comp) {
+static int readrids(struct net_device *dev, aironet_ioctl *comp)
+{
 	unsigned short ridcode;
 	unsigned char *iobuf;
 	int len;
@@ -7801,7 +7830,7 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 	case AIROGSTATSC32: ridcode = RID_STATS;        break;
 	case AIROGMICSTATS:
 		if (copy_to_user(comp->data, &ai->micstats,
-				 min((int)comp->len,(int)sizeof(ai->micstats))))
+				 min((int)comp->len, (int)sizeof(ai->micstats))))
 			return -EFAULT;
 		return 0;
 	case AIRORRID:      ridcode = comp->ridnum;     break;
@@ -7818,7 +7847,7 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
 	if ((iobuf = kzalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
-	PC4500_readrid(ai,ridcode,iobuf,RIDSIZE, 1);
+	PC4500_readrid(ai, ridcode, iobuf, RIDSIZE, 1);
 	/* get the count of bytes in the rid  docs say 1st 2 bytes is it.
 	 * then return it to the user
 	 * 9/22/2000 Honor user given length
@@ -7837,7 +7866,8 @@ static int readrids(struct net_device *dev, aironet_ioctl *comp) {
  * Danger Will Robinson write the rids here
  */
 
-static int writerids(struct net_device *dev, aironet_ioctl *comp) {
+static int writerids(struct net_device *dev, aironet_ioctl *comp)
+{
 	struct airo_info *ai = dev->ml_priv;
 	int  ridcode;
         int  enabled;
@@ -7894,10 +7924,10 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
 		if ((iobuf = kmalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 			return -ENOMEM;
 
-		PC4500_readrid(ai,RID_STATSDELTACLEAR,iobuf,RIDSIZE, 1);
+		PC4500_readrid(ai, RID_STATSDELTACLEAR, iobuf, RIDSIZE, 1);
 
 		enabled = ai->micstats.enabled;
-		memset(&ai->micstats,0,sizeof(ai->micstats));
+		memset(&ai->micstats, 0, sizeof(ai->micstats));
 		ai->micstats.enabled = enabled;
 
 		if (copy_to_user(comp->data, iobuf,
@@ -7911,13 +7941,13 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
 	default:
 		return -EOPNOTSUPP;	/* Blarg! */
 	}
-	if(comp->len > RIDSIZE)
+	if (comp->len > RIDSIZE)
 		return -EINVAL;
 
 	if ((iobuf = kmalloc(RIDSIZE, GFP_KERNEL)) == NULL)
 		return -ENOMEM;
 
-	if (copy_from_user(iobuf,comp->data,comp->len)) {
+	if (copy_from_user(iobuf, comp->data, comp->len)) {
 		kfree (iobuf);
 		return -EFAULT;
 	}
@@ -7934,7 +7964,7 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
 			clear_bit (FLAG_ADHOC, &ai->flags);
 	}
 
-	if((*writer)(ai, ridcode, iobuf,comp->len,1)) {
+	if ((*writer)(ai, ridcode, iobuf, comp->len, 1)) {
 		kfree (iobuf);
 		return -EIO;
 	}
@@ -7951,7 +7981,8 @@ static int writerids(struct net_device *dev, aironet_ioctl *comp) {
  * Flash command switch table
  */
 
-static int flashcard(struct net_device *dev, aironet_ioctl *comp) {
+static int flashcard(struct net_device *dev, aironet_ioctl *comp)
+{
 	int z;
 
 	/* Only super-user can modify flash */
@@ -7970,23 +8001,23 @@ static int flashcard(struct net_device *dev, aironet_ioctl *comp) {
 		return setflashmode((struct airo_info *)dev->ml_priv);
 
 	case AIROFLSHGCHR: /* Get char from aux */
-		if(comp->len != sizeof(int))
+		if (comp->len != sizeof(int))
 			return -EINVAL;
-		if (copy_from_user(&z,comp->data,comp->len))
+		if (copy_from_user(&z, comp->data, comp->len))
 			return -EFAULT;
 		return flashgchar((struct airo_info *)dev->ml_priv, z, 8000);
 
 	case AIROFLSHPCHR: /* Send char to card. */
-		if(comp->len != sizeof(int))
+		if (comp->len != sizeof(int))
 			return -EINVAL;
-		if (copy_from_user(&z,comp->data,comp->len))
+		if (copy_from_user(&z, comp->data, comp->len))
 			return -EFAULT;
 		return flashpchar((struct airo_info *)dev->ml_priv, z, 8000);
 
 	case AIROFLPUTBUF: /* Send 32k to card */
 		if (!AIRO_FLASH(dev))
 			return -ENOMEM;
-		if(comp->len > FLASHSIZE)
+		if (comp->len > FLASHSIZE)
 			return -EINVAL;
 		if (copy_from_user(AIRO_FLASH(dev), comp->data, comp->len))
 			return -EFAULT;
@@ -8010,19 +8041,20 @@ static int flashcard(struct net_device *dev, aironet_ioctl *comp) {
  * card.
  */
 
-static int cmdreset(struct airo_info *ai) {
+static int cmdreset(struct airo_info *ai)
+{
 	disable_MAC(ai, 1);
 
-	if(!waitbusy (ai)){
+	if (!waitbusy (ai)) {
 		airo_print_info(ai->dev->name, "Waitbusy hang before RESET");
 		return -EBUSY;
 	}
 
-	OUT4500(ai,COMMAND,CMD_SOFTRESET);
+	OUT4500(ai, COMMAND, CMD_SOFTRESET);
 
 	ssleep(1);			/* WAS 600 12/7/00 */
 
-	if(!waitbusy (ai)){
+	if (!waitbusy (ai)) {
 		airo_print_info(ai->dev->name, "Waitbusy hang AFTER RESET");
 		return -EBUSY;
 	}
@@ -8034,22 +8066,23 @@ static int cmdreset(struct airo_info *ai) {
  * mode
  */
 
-static int setflashmode (struct airo_info *ai) {
+static int setflashmode (struct airo_info *ai)
+{
 	set_bit (FLAG_FLASHING, &ai->flags);
 
 	OUT4500(ai, SWS0, FLASH_COMMAND);
 	OUT4500(ai, SWS1, FLASH_COMMAND);
 	if (probe) {
 		OUT4500(ai, SWS0, FLASH_COMMAND);
-		OUT4500(ai, COMMAND,0x10);
+		OUT4500(ai, COMMAND, 0x10);
 	} else {
 		OUT4500(ai, SWS2, FLASH_COMMAND);
 		OUT4500(ai, SWS3, FLASH_COMMAND);
-		OUT4500(ai, COMMAND,0);
+		OUT4500(ai, COMMAND, 0);
 	}
 	msleep(500);		/* 500ms delay */
 
-	if(!waitbusy(ai)) {
+	if (!waitbusy(ai)) {
 		clear_bit (FLAG_FLASHING, &ai->flags);
 		airo_print_info(ai->dev->name, "Waitbusy hang after setflash mode");
 		return -EIO;
@@ -8061,16 +8094,17 @@ static int setflashmode (struct airo_info *ai) {
  * x 50us for  echo .
  */
 
-static int flashpchar(struct airo_info *ai,int byte,int dwelltime) {
+static int flashpchar(struct airo_info *ai, int byte, int dwelltime)
+{
 	int echo;
 	int waittime;
 
 	byte |= 0x8000;
 
-	if(dwelltime == 0 )
+	if (dwelltime == 0)
 		dwelltime = 200;
 
-	waittime=dwelltime;
+	waittime = dwelltime;
 
 	/* Wait for busy bit d15 to go false indicating buffer empty */
 	while ((IN4500 (ai, SWS0) & 0x8000) && waittime > 0) {
@@ -8079,20 +8113,20 @@ static int flashpchar(struct airo_info *ai,int byte,int dwelltime) {
 	}
 
 	/* timeout for busy clear wait */
-	if(waittime <= 0 ){
+	if (waittime <= 0) {
 		airo_print_info(ai->dev->name, "flash putchar busywait timeout!");
 		return -EBUSY;
 	}
 
 	/* Port is clear now write byte and wait for it to echo back */
 	do {
-		OUT4500(ai,SWS0,byte);
+		OUT4500(ai, SWS0, byte);
 		udelay(50);
 		dwelltime -= 50;
-		echo = IN4500(ai,SWS1);
+		echo = IN4500(ai, SWS1);
 	} while (dwelltime >= 0 && echo != byte);
 
-	OUT4500(ai,SWS1,0);
+	OUT4500(ai, SWS1, 0);
 
 	return (echo == byte) ? 0 : -EIO;
 }
@@ -8101,29 +8135,30 @@ static int flashpchar(struct airo_info *ai,int byte,int dwelltime) {
  * Get a character from the card matching matchbyte
  * Step 3)
  */
-static int flashgchar(struct airo_info *ai,int matchbyte,int dwelltime){
+static int flashgchar(struct airo_info *ai, int matchbyte, int dwelltime)
+{
 	int           rchar;
-	unsigned char rbyte=0;
+	unsigned char rbyte = 0;
 
 	do {
-		rchar = IN4500(ai,SWS1);
+		rchar = IN4500(ai, SWS1);
 
-		if(dwelltime && !(0x8000 & rchar)){
+		if (dwelltime && !(0x8000 & rchar)) {
 			dwelltime -= 10;
 			mdelay(10);
 			continue;
 		}
 		rbyte = 0xff & rchar;
 
-		if( (rbyte == matchbyte) && (0x8000 & rchar) ){
-			OUT4500(ai,SWS1,0);
+		if ((rbyte == matchbyte) && (0x8000 & rchar)) {
+			OUT4500(ai, SWS1, 0);
 			return 0;
 		}
-		if( rbyte == 0x81 || rbyte == 0x82 || rbyte == 0x83 || rbyte == 0x1a || 0xffff == rchar)
+		if (rbyte == 0x81 || rbyte == 0x82 || rbyte == 0x83 || rbyte == 0x1a || 0xffff == rchar)
 			break;
-		OUT4500(ai,SWS1,0);
+		OUT4500(ai, SWS1, 0);
 
-	}while(dwelltime > 0);
+	} while (dwelltime > 0);
 	return -EIO;
 }
 
@@ -8132,21 +8167,22 @@ static int flashgchar(struct airo_info *ai,int matchbyte,int dwelltime){
  * send to the card
  */
 
-static int flashputbuf(struct airo_info *ai){
+static int flashputbuf(struct airo_info *ai)
+{
 	int            nwords;
 
 	/* Write stuff */
 	if (test_bit(FLAG_MPI,&ai->flags))
 		memcpy_toio(ai->pciaux + 0x8000, ai->flash, FLASHSIZE);
 	else {
-		OUT4500(ai,AUXPAGE,0x100);
-		OUT4500(ai,AUXOFF,0);
+		OUT4500(ai, AUXPAGE, 0x100);
+		OUT4500(ai, AUXOFF, 0);
 
-		for(nwords=0;nwords != FLASHSIZE / 2;nwords++){
-			OUT4500(ai,AUXDATA,ai->flash[nwords] & 0xffff);
+		for (nwords = 0; nwords != FLASHSIZE / 2; nwords++) {
+			OUT4500(ai, AUXDATA, ai->flash[nwords] & 0xffff);
 		}
 	}
-	OUT4500(ai,SWS0,0x8000);
+	OUT4500(ai, SWS0, 0x8000);
 
 	return 0;
 }
@@ -8154,8 +8190,9 @@ static int flashputbuf(struct airo_info *ai){
 /*
  *
  */
-static int flashrestart(struct airo_info *ai,struct net_device *dev){
-	int    i,status;
+static int flashrestart(struct airo_info *ai, struct net_device *dev)
+{
+	int    i, status;
 
 	ssleep(1);			/* Added 12/7/00 */
 	clear_bit (FLAG_FLASHING, &ai->flags);
@@ -8167,9 +8204,9 @@ static int flashrestart(struct airo_info *ai,struct net_device *dev){
 	status = setup_card(ai, dev->dev_addr, 1);
 
 	if (!test_bit(FLAG_MPI,&ai->flags))
-		for( i = 0; i < MAX_FIDS; i++ ) {
+		for (i = 0; i < MAX_FIDS; i++) {
 			ai->fids[i] = transmit_allocate
-				( ai, AIRO_DEF_MTU, i >= MAX_FIDS / 2 );
+				(ai, AIRO_DEF_MTU, i >= MAX_FIDS / 2);
 		}
 
 	ssleep(1);			/* Added 12/7/00 */
-- 
2.25.1

