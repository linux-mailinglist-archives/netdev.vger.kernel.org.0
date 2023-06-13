Return-Path: <netdev+bounces-10404-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B35072E59F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:24:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6801C1C20C8A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A81C38CD0;
	Tue, 13 Jun 2023 14:24:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADB534CED
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:24:08 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01204BA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:24:05 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 27AC361E5FE01;
	Tue, 13 Jun 2023 16:23:43 +0200 (CEST)
Message-ID: <caa3dcba-187a-a8db-1ecb-74155414a43f@molgen.mpg.de>
Date: Tue, 13 Jun 2023 16:23:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [Intel-wired-lan] [PATCH iwl-next 2/2] iavf: make functions
 static where possible
Content-Language: en-US
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
 Tony Nguyen <anthony.l.nguyen@intel.com>
References: <20230613141253.57811-1-przemyslaw.kitszel@intel.com>
 <20230613141253.57811-3-przemyslaw.kitszel@intel.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230613141253.57811-3-przemyslaw.kitszel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Przemek,


Am 13.06.23 um 16:12 schrieb Przemek Kitszel:
> Make static all the possible funnctions.

functions

Maybe:

Make all possible functions static.


Kind regards,

Paul


> Move iavf_force_wb() up to avoid forward declaration.
> 
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> ---
>   drivers/net/ethernet/intel/iavf/iavf.h      | 10 -----
>   drivers/net/ethernet/intel/iavf/iavf_main.c | 14 +++----
>   drivers/net/ethernet/intel/iavf/iavf_txrx.c | 43 ++++++++++-----------
>   drivers/net/ethernet/intel/iavf/iavf_txrx.h |  4 --
>   4 files changed, 28 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
> index 8f29af80de8c..8cbdebc5b698 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
> @@ -526,9 +526,6 @@ void iavf_schedule_finish_config(struct iavf_adapter *adapter);
>   void iavf_reset(struct iavf_adapter *adapter);
>   void iavf_set_ethtool_ops(struct net_device *netdev);
>   void iavf_update_stats(struct iavf_adapter *adapter);
> -void iavf_reset_interrupt_capability(struct iavf_adapter *adapter);
> -int iavf_init_interrupt_scheme(struct iavf_adapter *adapter);
> -void iavf_irq_enable_queues(struct iavf_adapter *adapter);
>   void iavf_free_all_tx_resources(struct iavf_adapter *adapter);
>   void iavf_free_all_rx_resources(struct iavf_adapter *adapter);
>   
> @@ -582,12 +579,6 @@ void iavf_enable_vlan_stripping_v2(struct iavf_adapter *adapter, u16 tpid);
>   void iavf_disable_vlan_stripping_v2(struct iavf_adapter *adapter, u16 tpid);
>   void iavf_enable_vlan_insertion_v2(struct iavf_adapter *adapter, u16 tpid);
>   void iavf_disable_vlan_insertion_v2(struct iavf_adapter *adapter, u16 tpid);
> -int iavf_replace_primary_mac(struct iavf_adapter *adapter,
> -			     const u8 *new_mac);
> -void
> -iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
> -			       netdev_features_t prev_features,
> -			       netdev_features_t features);
>   void iavf_add_fdir_filter(struct iavf_adapter *adapter);
>   void iavf_del_fdir_filter(struct iavf_adapter *adapter);
>   void iavf_add_adv_rss_cfg(struct iavf_adapter *adapter);
> @@ -595,5 +586,4 @@ void iavf_del_adv_rss_cfg(struct iavf_adapter *adapter);
>   struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
>   					const u8 *macaddr);
>   int iavf_wait_for_reset(struct iavf_adapter *adapter);
> -int iavf_lock_timeout(struct mutex *lock, unsigned int msecs);
>   #endif /* _IAVF_H_ */
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index adb9d3fe1a28..a61d1692c91d 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -284,7 +284,7 @@ void iavf_free_virt_mem(struct iavf_hw *hw, struct iavf_virt_mem *mem)
>    *
>    * Returns 0 on success, negative on failure
>    **/
> -int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
> +static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
>   {
>   	unsigned int wait, delay = 10;
>   
> @@ -395,7 +395,7 @@ static void iavf_irq_disable(struct iavf_adapter *adapter)
>    * iavf_irq_enable_queues - Enable interrupt for all queues
>    * @adapter: board private structure
>    **/
> -void iavf_irq_enable_queues(struct iavf_adapter *adapter)
> +static void iavf_irq_enable_queues(struct iavf_adapter *adapter)
>   {
>   	struct iavf_hw *hw = &adapter->hw;
>   	int i;
> @@ -1036,8 +1036,8 @@ struct iavf_mac_filter *iavf_add_filter(struct iavf_adapter *adapter,
>    *
>    * Do not call this with mac_vlan_list_lock!
>    **/
> -int iavf_replace_primary_mac(struct iavf_adapter *adapter,
> -			     const u8 *new_mac)
> +static int iavf_replace_primary_mac(struct iavf_adapter *adapter,
> +				    const u8 *new_mac)
>   {
>   	struct iavf_hw *hw = &adapter->hw;
>   	struct iavf_mac_filter *new_f;
> @@ -1888,7 +1888,7 @@ static void iavf_free_q_vectors(struct iavf_adapter *adapter)
>    * @adapter: board private structure
>    *
>    **/
> -void iavf_reset_interrupt_capability(struct iavf_adapter *adapter)
> +static void iavf_reset_interrupt_capability(struct iavf_adapter *adapter)
>   {
>   	if (!adapter->msix_entries)
>   		return;
> @@ -1903,7 +1903,7 @@ void iavf_reset_interrupt_capability(struct iavf_adapter *adapter)
>    * @adapter: board private structure to initialize
>    *
>    **/
> -int iavf_init_interrupt_scheme(struct iavf_adapter *adapter)
> +static int iavf_init_interrupt_scheme(struct iavf_adapter *adapter)
>   {
>   	int err;
>   
> @@ -2272,7 +2272,7 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
>    * the watchdog if any changes are requested to expedite the request via
>    * virtchnl.
>    **/
> -void
> +static void
>   iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
>   			       netdev_features_t prev_features,
>   			       netdev_features_t features)
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> index e989feda133c..8c5f6096b002 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
> @@ -54,7 +54,7 @@ static void iavf_unmap_and_free_tx_resource(struct iavf_ring *ring,
>    * iavf_clean_tx_ring - Free any empty Tx buffers
>    * @tx_ring: ring to be cleaned
>    **/
> -void iavf_clean_tx_ring(struct iavf_ring *tx_ring)
> +static void iavf_clean_tx_ring(struct iavf_ring *tx_ring)
>   {
>   	unsigned long bi_size;
>   	u16 i;
> @@ -110,7 +110,7 @@ void iavf_free_tx_resources(struct iavf_ring *tx_ring)
>    * Since there is no access to the ring head register
>    * in XL710, we need to use our local copies
>    **/
> -u32 iavf_get_tx_pending(struct iavf_ring *ring, bool in_sw)
> +static u32 iavf_get_tx_pending(struct iavf_ring *ring, bool in_sw)
>   {
>   	u32 head, tail;
>   
> @@ -127,6 +127,24 @@ u32 iavf_get_tx_pending(struct iavf_ring *ring, bool in_sw)
>   	return 0;
>   }
>   
> +/**
> + * iavf_force_wb - Issue SW Interrupt so HW does a wb
> + * @vsi: the VSI we care about
> + * @q_vector: the vector on which to force writeback
> + **/
> +static void iavf_force_wb(struct iavf_vsi *vsi, struct iavf_q_vector *q_vector)
> +{
> +	u32 val = IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
> +		  IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK | /* set noitr */
> +		  IAVF_VFINT_DYN_CTLN1_SWINT_TRIG_MASK |
> +		  IAVF_VFINT_DYN_CTLN1_SW_ITR_INDX_ENA_MASK
> +		  /* allow 00 to be written to the index */;
> +
> +	wr32(&vsi->back->hw,
> +	     IAVF_VFINT_DYN_CTLN1(q_vector->reg_idx),
> +	     val);
> +}
> +
>   /**
>    * iavf_detect_recover_hung - Function to detect and recover hung_queues
>    * @vsi:  pointer to vsi struct with tx queues
> @@ -352,25 +370,6 @@ static void iavf_enable_wb_on_itr(struct iavf_vsi *vsi,
>   	q_vector->arm_wb_state = true;
>   }
>   
> -/**
> - * iavf_force_wb - Issue SW Interrupt so HW does a wb
> - * @vsi: the VSI we care about
> - * @q_vector: the vector  on which to force writeback
> - *
> - **/
> -void iavf_force_wb(struct iavf_vsi *vsi, struct iavf_q_vector *q_vector)
> -{
> -	u32 val = IAVF_VFINT_DYN_CTLN1_INTENA_MASK |
> -		  IAVF_VFINT_DYN_CTLN1_ITR_INDX_MASK | /* set noitr */
> -		  IAVF_VFINT_DYN_CTLN1_SWINT_TRIG_MASK |
> -		  IAVF_VFINT_DYN_CTLN1_SW_ITR_INDX_ENA_MASK
> -		  /* allow 00 to be written to the index */;
> -
> -	wr32(&vsi->back->hw,
> -	     IAVF_VFINT_DYN_CTLN1(q_vector->reg_idx),
> -	     val);
> -}
> -
>   static inline bool iavf_container_is_rx(struct iavf_q_vector *q_vector,
>   					struct iavf_ring_container *rc)
>   {
> @@ -687,7 +686,7 @@ int iavf_setup_tx_descriptors(struct iavf_ring *tx_ring)
>    * iavf_clean_rx_ring - Free Rx buffers
>    * @rx_ring: ring to be cleaned
>    **/
> -void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
> +static void iavf_clean_rx_ring(struct iavf_ring *rx_ring)
>   {
>   	unsigned long bi_size;
>   	u16 i;
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.h b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> index 2624bf6d009e..7e6ee32d19b6 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> +++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.h
> @@ -442,15 +442,11 @@ static inline unsigned int iavf_rx_pg_order(struct iavf_ring *ring)
>   
>   bool iavf_alloc_rx_buffers(struct iavf_ring *rxr, u16 cleaned_count);
>   netdev_tx_t iavf_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
> -void iavf_clean_tx_ring(struct iavf_ring *tx_ring);
> -void iavf_clean_rx_ring(struct iavf_ring *rx_ring);
>   int iavf_setup_tx_descriptors(struct iavf_ring *tx_ring);
>   int iavf_setup_rx_descriptors(struct iavf_ring *rx_ring);
>   void iavf_free_tx_resources(struct iavf_ring *tx_ring);
>   void iavf_free_rx_resources(struct iavf_ring *rx_ring);
>   int iavf_napi_poll(struct napi_struct *napi, int budget);
> -void iavf_force_wb(struct iavf_vsi *vsi, struct iavf_q_vector *q_vector);
> -u32 iavf_get_tx_pending(struct iavf_ring *ring, bool in_sw);
>   void iavf_detect_recover_hung(struct iavf_vsi *vsi);
>   int __iavf_maybe_stop_tx(struct iavf_ring *tx_ring, int size);
>   bool __iavf_chk_linearize(struct sk_buff *skb);

