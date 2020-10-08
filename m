Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357DF287521
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgJHNPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:15:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52164 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgJHNPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:15:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098D9a9C153950;
        Thu, 8 Oct 2020 13:15:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=+1QLEGAwYoRd62Sa53eBD0n26ybUrAnFVEtyjEaC1Xs=;
 b=XiL78+Dj7arI79pGW1TgipbtA4yI1aYlEeFa1fBZBjQrNRYutQOWDEqYOWXyIqOCIY/L
 7LSaNzNLJA0JGIzXrue4w3RXGSNrIsq5YY7p6RkcpIEjO8MIjpXmgDku7YrAEnLcYSvN
 1Xy0Mv1v4BjGMFrr3Z+MSi0zML7+AiFYi4xhOR6eQczhI254TO0vM8xRyzWENplDbEcK
 LEgwgQLu67j+Ixewx9QKxGuimgPM6zwcndprQRRLmSh8sZgHpjLmALmSuiO345Yyo8kf
 CUijzHjguJQl+TyQRlwpRZxRIQvRgBmjdHv6vhN2ND2caZ7uoIp+2j6ugZSMwduItBle Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33xhxn7gdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 13:15:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098DAu7Y096321;
        Thu, 8 Oct 2020 13:13:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3410k14w15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 13:13:28 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 098DDROF023631;
        Thu, 8 Oct 2020 13:13:27 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 06:13:26 -0700
Date:   Thu, 8 Oct 2020 16:13:20 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 0/7] wfx: move out from the staging area
Message-ID: <20201008131320.GA1042@kadam>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some static checker warnings to look at from linux-next from
Tuesday.

drivers/staging/wfx/hif_tx.c:319 hif_join() error: we previously assumed 'channel' could be null (see line 315)
drivers/staging/wfx/main.c:228 wfx_send_pdata_pds() warn: potential NULL parameter dereference 'tmp_buf'
drivers/staging/wfx/hif_rx.c:177 hif_scan_complete_indication() warn: potential NULL parameter dereference 'wvif'
drivers/staging/wfx/data_tx.c:576 wfx_flush() warn: potential NULL parameter dereference 'wvif'
drivers/staging/wfx/bus_spi.c:228 wfx_spi_probe() warn: 'bus->core' could be an error pointer
drivers/staging/wfx/bus_sdio.c:221 wfx_sdio_probe() warn: 'bus->core' could be an error pointer
drivers/staging/wfx/hif_rx.c:26 hif_generic_confirm() warn: negative user subtract: 0-u16max - 4
drivers/staging/wfx/hif_rx.c:98 hif_wakeup_indication() warn: 'gpiod_get_value(wdev->pdata.gpio_wakeup)' returns positive and negative
drivers/staging/wfx/bh.c:24 device_wakeup() warn: 'gpiod_get_value_cansleep(wdev->pdata.gpio_wakeup)' returns positive and negative
drivers/staging/wfx/hif_rx.c:235 hif_generic_indication() warn: format string contains non-ascii character '\xc2'
drivers/staging/wfx/hif_rx.c:235 hif_generic_indication() warn: format string contains non-ascii character '\xb0'
drivers/staging/wfx/data_tx.c:37 wfx_get_hw_rate() warn: constraint '(struct ieee80211_supported_band)->bitrates' overflow 'band->bitrates' 0 <= abs_rl '0-127' user_rl '' required = '(struct ieee80211_supported_band)->n_bitrates'

Some of these are unpublished checks that I haven't published because
they are too crap.  The rest of the email is just long explanations.
Skip if not required.

regards,
dan carpenter

#1
drivers/staging/wfx/hif_tx.c:319 hif_join() error: we previously assumed 'channel' could be null (see line 315)
   311          if (!hif)
   312                  return -ENOMEM;
   313          body->infrastructure_bss_mode = !conf->ibss_joined;
   314          body->short_preamble = conf->use_short_preamble;
   315          if (channel && channel->flags & IEEE80211_CHAN_NO_IR)
                    ^^^^^^^
Check for NULL.

   316                  body->probe_for_join = 0;
   317          else
   318                  body->probe_for_join = 1;
   319          body->channel_number = channel->hw_value;
                                       ^^^^^^^^^^^^^^^^^
Unchecked dereference.

   320          body->beacon_interval = cpu_to_le32(conf->beacon_int);
   321          body->basic_rate_set =

#2
drivers/staging/wfx/main.c:228 wfx_send_pdata_pds() warn: potential NULL parameter dereference 'tmp_buf'
   227          tmp_buf = kmemdup(pds->data, pds->size, GFP_KERNEL);

No check for allocation failure.

   228          ret = wfx_send_pds(wdev, tmp_buf, pds->size);
   229          kfree(tmp_buf);

#3
drivers/staging/wfx/hif_rx.c:177 hif_scan_complete_indication() warn: potential NULL parameter dereference 'wvif'
   170  static int hif_scan_complete_indication(struct wfx_dev *wdev,
   171                                          const struct hif_msg *hif,
   172                                          const void *buf)
   173  {
   174          struct wfx_vif *wvif = wdev_to_wvif(wdev, hif->interface);
                                ^^^^^^^^^^^^^^^^^^^
Smatch thinks wdev_to_wvif() can return NULL.

   175  
   176          WARN_ON(!wvif);
   177          wfx_scan_complete(wvif);
   178  
   179          return 0;
   180  }

#4
drivers/staging/wfx/data_tx.c:576 wfx_flush() warn: potential NULL parameter dereference 'wvif'
   572          while ((skb = skb_dequeue(&dropped)) != NULL) {
   573                  hif = (struct hif_msg *)skb->data;
   574                  wvif = wdev_to_wvif(wdev, hif->interface);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Same.
   575                  ieee80211_tx_info_clear_status(IEEE80211_SKB_CB(skb));
   576                  wfx_skb_dtor(wvif, skb);
   577          }
   578  }

#5 and #6
drivers/staging/wfx/bus_spi.c:228 wfx_spi_probe() warn: 'bus->core' could be an error pointer
drivers/staging/wfx/bus_sdio.c:221 wfx_sdio_probe() warn: 'bus->core' could be an error pointer

The wfx_init_common() function should return NULL instead of error
pointer if devm_gpiod_get_optional() fails.

#7
drivers/staging/wfx/hif_rx.c:26 hif_generic_confirm() warn: negative user subtract: 0-u16max - 4
    20  static int hif_generic_confirm(struct wfx_dev *wdev,
    21                                 const struct hif_msg *hif, const void *buf)
    22  {
    23          // All confirm messages start with status
    24          int status = le32_to_cpup((__le32 *)buf);
    25          int cmd = hif->id;
    26          int len = le16_to_cpu(hif->len) - 4; // drop header

Can "len" get set to negative 4?

    27  
    28          WARN(!mutex_is_locked(&wdev->hif_cmd.lock), "data locking error");


#8 and #9
drivers/staging/wfx/hif_rx.c:98 hif_wakeup_indication() warn: 'gpiod_get_value(wdev->pdata.gpio_wakeup)' returns positive and negative
drivers/staging/wfx/bh.c:24 device_wakeup() warn: 'gpiod_get_value_cansleep(wdev->pdata.gpio_wakeup)' returns positive and negative
    94  static int hif_wakeup_indication(struct wfx_dev *wdev,
    95                                   const struct hif_msg *hif, const void *buf)
    96  {
    97          if (!wdev->pdata.gpio_wakeup
    98              || !gpiod_get_value(wdev->pdata.gpio_wakeup)) {
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Negative error codes from gpiod_get_value() should be treated as error.

    99                  dev_warn(wdev->dev, "unexpected wake-up indication\n");
   100                  return -EIO;
   101          }
   102          return 0;
   103  }

#10 and #11
drivers/staging/wfx/hif_rx.c:235 hif_generic_indication() warn: format string contains non-ascii character '\xc2'
drivers/staging/wfx/hif_rx.c:235 hif_generic_indication() warn: format string contains non-ascii character '\xb0'
   234                  if (!wfx_api_older_than(wdev, 1, 4))
   235                          dev_info(wdev->dev, "Rx test ongoing. Temperature: %d°C\n",
                                                                                     ^
Can we output non-ascii to dmesg?  (I didn't add this Smatch check so I
don't really know the answer).

   236                                   body->data.rx_stats.current_temp);

#12
drivers/staging/wfx/data_tx.c:37 wfx_get_hw_rate() warn: constraint '(struct ieee80211_supported_band)->bitrates' overflow 'band->bitrates' 0 <= abs_rl '0-127' user_rl '' required = '(struct ieee80211_supported_band)->n_bitrates'

    20  static int wfx_get_hw_rate(struct wfx_dev *wdev,
    21                             const struct ieee80211_tx_rate *rate)
    22  {
    23          struct ieee80211_supported_band *band;
    24  
    25          if (rate->idx < 0)
    26                  return -1;
    27          if (rate->flags & IEEE80211_TX_RC_MCS) {
    28                  if (rate->idx > 7) {
    29                          WARN(1, "wrong rate->idx value: %d", rate->idx);
    30                          return -1;
    31                  }
    32                  return rate->idx + 14;
    33          }
    34          // WFx only support 2GHz, else band information should be retrieved
    35          // from ieee80211_tx_info
    36          band = wdev->hw->wiphy->bands[NL80211_BAND_2GHZ];
    37          return band->bitrates[rate->idx].hw_value;

This code assumes that "rate->idx" can be all sort of invalid values
including negatives but it doesn't cap it against:

	if (rate->idx >= band->n_bitrates)
		return -1;

    38  }

If you you read all the way down to the second end of the email then you
are a true hero.  regards again,
dan carpenter
