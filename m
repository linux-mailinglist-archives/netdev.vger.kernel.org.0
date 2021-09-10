Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB47406F9E
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhIJQ2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIJQ2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 12:28:34 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423D6C061574;
        Fri, 10 Sep 2021 09:27:23 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y6so4114057lje.2;
        Fri, 10 Sep 2021 09:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=G+xktSFAQ1dxOc7V/JtqKYyvJz/KlBsA2cIgn6rLykI=;
        b=Agn/JD3Ot2TRz/RjQF11nIZA94FgPL4W9t9jnu4fYLekvU1tIy+t4MbzdS10aAFa6h
         pevuJh/ivk3MdQSFxe9BFIKLMl8XBSPzqUHNkju/oxAhzHd7HtFJ+eXw4TAYdQLImKAR
         J7fFTtftkAWo70TJh4zedVzUDfEM/5I1G+oJYfx6rUJFF14F+FCq1C62sq798AYG5Iss
         KKg58U0pqcqH+0mbxbbh87Dxbyi/g6Gz8HwETtzYIQn1pR6r0L8feRfKZVkqKxDGneTV
         3PmMR7fnhQV1IriYwPVWlE3OUUhHAaJE/dIqLKx9oE+Wwns6KVjFcMhr8QB+IcyNTZ2P
         7C8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=G+xktSFAQ1dxOc7V/JtqKYyvJz/KlBsA2cIgn6rLykI=;
        b=4esedYcEivApDDAGIGS5tNr/6VBa9IwvxWZc5GIrET40O/ZvqZgJ5d/W4v6nEhqtnn
         jvAp3CQe6vUM9ISbGvT/zlNmmxz95o/Fv+9Ziqrgof8DnYpwz+W+2ExnfAbH1NK+C9Bl
         3BmHCMsYDAZKHBP3NMj67AeHh7J46CedG7drftA8io+ohOoIXchScsLJb5x0cvUiVidX
         TStwCaHniDW6LTjTbFR+brIDD1zg7tXuODlVhxOUL7v40Ayvq/FMWHtKipFJA2zzltcF
         hJTzBdDrSimOZRxngmcMdKIcqYAf6xUcgIUBb6d+/zXEPSmMUqnkL23WtbLB6uPDoEZS
         Tqnw==
X-Gm-Message-State: AOAM533+SEyr7RIsG61yVNkroOjPgyVNpwOrV7BEoiEg8iyZuSyl2S1E
        KFWKHV+Ytc4PyLSF4dneoxs=
X-Google-Smtp-Source: ABdhPJxzeqFCXFBMkhVksOW3ZfVt/hIvQ54oFj4QqJ95uMcOiOhtgcxDjP4OQT5RauSBV7Zr+Cg8JQ==
X-Received: by 2002:a2e:7d13:: with SMTP id y19mr4805711ljc.344.1631291241537;
        Fri, 10 Sep 2021 09:27:21 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id 10sm620378ljp.12.2021.09.10.09.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:27:20 -0700 (PDT)
Date:   Fri, 10 Sep 2021 19:27:18 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 29/31] staging: wfx: remove useless comments after #endif
Message-ID: <20210910162718.tjcwwxtxbr3ugdgf@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-30-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910160504.1794332-30-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:05:02PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Comments after the last #endif of header files don't bring any
> information and are redundant with the name of the file. Drop them.

How so? You see right away that this indeed is header guard and not some
other random thing. Also kernel coding standard says:

	At the end of any non-trivial #if or #ifdef block (more than a
	few line), place a comment after the #endif on the same line,
	noting the conditional expression used.

There is no point dropping them imo. If you think about space saving
this patch will take more space. Because it will be in version history.
So nack from me unless some one can trun my head around.

> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/bh.h      | 2 +-
>  drivers/staging/wfx/data_rx.h | 2 +-
>  drivers/staging/wfx/data_tx.h | 2 +-
>  drivers/staging/wfx/debug.h   | 2 +-
>  drivers/staging/wfx/fwio.h    | 2 +-
>  drivers/staging/wfx/hwio.h    | 2 +-
>  drivers/staging/wfx/key.h     | 2 +-
>  drivers/staging/wfx/queue.h   | 2 +-
>  drivers/staging/wfx/scan.h    | 2 +-
>  drivers/staging/wfx/sta.h     | 2 +-
>  drivers/staging/wfx/wfx.h     | 2 +-
>  11 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/wfx/bh.h b/drivers/staging/wfx/bh.h
> index f08c62ed039c..6c121ce4dd3f 100644
> --- a/drivers/staging/wfx/bh.h
> +++ b/drivers/staging/wfx/bh.h
> @@ -30,4 +30,4 @@ void wfx_bh_request_rx(struct wfx_dev *wdev);
>  void wfx_bh_request_tx(struct wfx_dev *wdev);
>  void wfx_bh_poll_irq(struct wfx_dev *wdev);
>  
> -#endif /* WFX_BH_H */
> +#endif
> diff --git a/drivers/staging/wfx/data_rx.h b/drivers/staging/wfx/data_rx.h
> index f79545c06130..84d0e3c0507b 100644
> --- a/drivers/staging/wfx/data_rx.h
> +++ b/drivers/staging/wfx/data_rx.h
> @@ -15,4 +15,4 @@ struct hif_ind_rx;
>  void wfx_rx_cb(struct wfx_vif *wvif,
>  	       const struct hif_ind_rx *arg, struct sk_buff *skb);
>  
> -#endif /* WFX_DATA_RX_H */
> +#endif
> diff --git a/drivers/staging/wfx/data_tx.h b/drivers/staging/wfx/data_tx.h
> index dafd8fef44cf..15590a8faefe 100644
> --- a/drivers/staging/wfx/data_tx.h
> +++ b/drivers/staging/wfx/data_tx.h
> @@ -65,4 +65,4 @@ static inline struct hif_req_tx *wfx_skb_txreq(struct sk_buff *skb)
>  	return req;
>  }
>  
> -#endif /* WFX_DATA_TX_H */
> +#endif
> diff --git a/drivers/staging/wfx/debug.h b/drivers/staging/wfx/debug.h
> index 6f2f84d64c9e..4b9c49a9fffb 100644
> --- a/drivers/staging/wfx/debug.h
> +++ b/drivers/staging/wfx/debug.h
> @@ -16,4 +16,4 @@ const char *get_hif_name(unsigned long id);
>  const char *get_mib_name(unsigned long id);
>  const char *get_reg_name(unsigned long id);
>  
> -#endif /* WFX_DEBUG_H */
> +#endif
> diff --git a/drivers/staging/wfx/fwio.h b/drivers/staging/wfx/fwio.h
> index 6028f92503fe..eeea61210eca 100644
> --- a/drivers/staging/wfx/fwio.h
> +++ b/drivers/staging/wfx/fwio.h
> @@ -12,4 +12,4 @@ struct wfx_dev;
>  
>  int wfx_init_device(struct wfx_dev *wdev);
>  
> -#endif /* WFX_FWIO_H */
> +#endif
> diff --git a/drivers/staging/wfx/hwio.h b/drivers/staging/wfx/hwio.h
> index 9a361ed95ecb..ff09575dd1af 100644
> --- a/drivers/staging/wfx/hwio.h
> +++ b/drivers/staging/wfx/hwio.h
> @@ -72,4 +72,4 @@ int control_reg_write_bits(struct wfx_dev *wdev, u32 mask, u32 val);
>  int igpr_reg_read(struct wfx_dev *wdev, int index, u32 *val);
>  int igpr_reg_write(struct wfx_dev *wdev, int index, u32 val);
>  
> -#endif /* WFX_HWIO_H */
> +#endif
> diff --git a/drivers/staging/wfx/key.h b/drivers/staging/wfx/key.h
> index dd189788acf1..2d135eff7af2 100644
> --- a/drivers/staging/wfx/key.h
> +++ b/drivers/staging/wfx/key.h
> @@ -17,4 +17,4 @@ int wfx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  		struct ieee80211_vif *vif, struct ieee80211_sta *sta,
>  		struct ieee80211_key_conf *key);
>  
> -#endif /* WFX_STA_H */
> +#endif
> diff --git a/drivers/staging/wfx/queue.h b/drivers/staging/wfx/queue.h
> index 54b5def2e24c..edd0d018b198 100644
> --- a/drivers/staging/wfx/queue.h
> +++ b/drivers/staging/wfx/queue.h
> @@ -42,4 +42,4 @@ unsigned int wfx_pending_get_pkt_us_delay(struct wfx_dev *wdev,
>  					  struct sk_buff *skb);
>  void wfx_pending_dump_old_frames(struct wfx_dev *wdev, unsigned int limit_ms);
>  
> -#endif /* WFX_QUEUE_H */
> +#endif
> diff --git a/drivers/staging/wfx/scan.h b/drivers/staging/wfx/scan.h
> index 562ca1321daf..78e3b984f375 100644
> --- a/drivers/staging/wfx/scan.h
> +++ b/drivers/staging/wfx/scan.h
> @@ -19,4 +19,4 @@ int wfx_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  void wfx_cancel_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
>  void wfx_scan_complete(struct wfx_vif *wvif, int nb_chan_done);
>  
> -#endif /* WFX_SCAN_H */
> +#endif
> diff --git a/drivers/staging/wfx/sta.h b/drivers/staging/wfx/sta.h
> index f359f375cc56..4d7e38be4235 100644
> --- a/drivers/staging/wfx/sta.h
> +++ b/drivers/staging/wfx/sta.h
> @@ -70,4 +70,4 @@ int wfx_update_pm(struct wfx_vif *wvif);
>  void wfx_reset(struct wfx_vif *wvif);
>  u32 wfx_rate_mask_to_hw(struct wfx_dev *wdev, u32 rates);
>  
> -#endif /* WFX_STA_H */
> +#endif
> diff --git a/drivers/staging/wfx/wfx.h b/drivers/staging/wfx/wfx.h
> index a4770f59f7d2..f8df59ad1639 100644
> --- a/drivers/staging/wfx/wfx.h
> +++ b/drivers/staging/wfx/wfx.h
> @@ -161,4 +161,4 @@ static inline int memzcmp(void *src, unsigned int size)
>  	return memcmp(buf, buf + 1, size - 1);
>  }
>  
> -#endif /* WFX_H */
> +#endif
> -- 
> 2.33.0
> 
