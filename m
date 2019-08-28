Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F2E9F918
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 06:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfH1EJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 00:09:46 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:43750 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfH1EJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 00:09:46 -0400
Received: by mail-pl1-f177.google.com with SMTP id 4so563978pld.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 21:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jx2sDR87Pojcfr/gHmKxz/8br94JslVxUn7kxvlHOCw=;
        b=wg7FuZIzIE4M8CQ+KHnhGLAmuK9TY5ZOJX+KVzqCeVHGKRl7XSwWlSL0ybq6s9JXTn
         m5Bogt4OqcHNBBoeR+ed+3NXZm2u/A7yVR8nCiYPH9qcf1pHGpyH1CQPHtBV7JPJLGjw
         /b+nKc1WjY2VAUgw4p5x8d0PkAmYjpG9UgaJ3l0e1LfH9pCeXR6hYwR1VVTZFppT1hnI
         2a/63VZOhklru27fqgDpvZ6dRCAyJlSjCHc7pBFQvlYrmxl5OqpTz5uSlmAfHAdbqN2s
         K60yqDbVgKR6c8tcVikYH6zdjsKihLkZ2T+7CdCmaZqWhHQhRZAmdYW/TLvmAnhuaKHW
         7kZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jx2sDR87Pojcfr/gHmKxz/8br94JslVxUn7kxvlHOCw=;
        b=EmURJ4ulf75fzaCsdH/NhGbSaAzd71Qq6T3blB/yMxVxIn0ObIzM3F88WVUnIuEgBI
         NA76E8GLfHNFxP+QNKNSwShLYjKGds+aupA1YDamerp18/8VTqxWWH8cnoQ8afFVhZEY
         Ig+yzSOIsD6MiCf3WnK9ftds/vvxw2uY93fL/gsKIQBRV33Ng6qSniJAzWw/o3qlhhHY
         MQviWq4rMIIEy0OCAGaKcpV/puGltW9f7z9FRfhQA+TFUbgg4bC8OaEbQOnk880qyddB
         4YRUdgFSIZ4rkI8jKrx589MKsT+xVfW2fV+5qsOaXtc6JzmWH0XR0xY7Zf98pjJ6iKSk
         GNSQ==
X-Gm-Message-State: APjAAAUIQepzOcW1KaJt4O0QMZnSY7PTZKu/Ap1Y8z/gNzMmxwkP2lYt
        YMPKhSEwTHyBeAp+34T7p59mHA==
X-Google-Smtp-Source: APXvYqx5d6KuBUPPL+9euZqQblUMVz/kaFRY++2Ri5I541kERbrJsUWkrPf4orvcyCsUrOdReuqrAg==
X-Received: by 2002:a17:902:7441:: with SMTP id e1mr2349692plt.332.1566965385588;
        Tue, 27 Aug 2019 21:09:45 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id v184sm828832pgd.34.2019.08.27.21.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 21:09:45 -0700 (PDT)
Date:   Tue, 27 Aug 2019 21:09:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com
Subject: Re: [net-next 00/15][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-26
Message-ID: <20190827210928.576c5fef@cakuba.netronome.com>
In-Reply-To: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
References: <20190827163832.8362-1-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 09:38:17 -0700, Jeff Kirsher wrote:
> This series contains updates to ice driver only.

Looks clear from uAPI perspective. It does mix fixes with -next, 
but I guess that's your call.

Code-wise changes like this are perhaps the low-light:

@@ -2105,7 +2108,10 @@ void ice_trigger_sw_intr(struct ice_hw *hw, struct ice_q_vector *q_vector)
  * @ring: Tx ring to be stopped
  * @txq_meta: Meta data of Tx ring to be stopped
  */
-static int
+#ifndef CONFIG_PCI_IOV
+static
+#endif /* !CONFIG_PCI_IOV */
+int
 ice_vsi_stop_tx_ring(struct ice_vsi *vsi, enum ice_disq_rst_src rst_src,
 		     u16 rel_vmvf_num, struct ice_ring *ring,
 		     struct ice_txq_meta *txq_meta)
