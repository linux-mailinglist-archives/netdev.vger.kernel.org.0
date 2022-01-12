Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D148BDE0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 05:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350702AbiALE3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 23:29:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:13698 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350698AbiALE3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 23:29:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641961772; x=1673497772;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=8Zd1Q5NzsO2AMYuW95wPeJM27wv0QIzvMoy7RYnSqa4=;
  b=JvMtXGOE661sZLc2+0WIyEruZUkzTvqIS2De5VvTlzFNvoohAaCObcoZ
   XcUTO3lDavEVdBCYJic6Qe8I1JNJLXZbYKlyqBBbE7E16c4h9ZPplfDA4
   VmTaXQhSSzivwjwM9Y0gV3kOl1jck3TpL8q4Cw64jHCT0qOH2nuWHTtdz
   x04/Xu28xspuLgriTquQWrxwhmpiGHP1/cqhzZbps40VGPnP8DuA1fFKM
   y+u1BEXJGMCREEMgeMMrwdgkbEFpCVOY0b1+vQinFlIvOFsYOZECUmWdD
   OxpVwzExS0tyTYugCQWPYa9EHXO0IvtK/UWimkufAjXI4G3BwyeS+pd9t
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="267998946"
X-IronPort-AV: E=Sophos;i="5.88,281,1635231600"; 
   d="scan'208";a="267998946"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 20:29:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,281,1635231600"; 
   d="scan'208";a="490616783"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.140.183]) ([10.212.140.183])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 20:29:31 -0800
Message-ID: <a808059a-a9a0-a6ad-5882-d30a8773f9e3@linux.intel.com>
Date:   Tue, 11 Jan 2022 20:29:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 06/14] net: wwan: t7xx: Add AT and MBIM WWAN ports
Content-Language: en-US
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com>
 <20211101035635.26999-7-ricardo.martinez@linux.intel.com>
 <CAHNKnsRe-88_jXvW4=0rPSDhVTbnJnDoeLpjHS4ouDv3pJXWSg@mail.gmail.com>
 <a9f1237c-78d5-d64e-6980-a7c7c5f6f5f9@linux.intel.com>
 <CAHNKnsSn9TRHdZiih6Y0geSD+e5CdY-uUeuvAvWdA0==e8GEEw@mail.gmail.com>
 <e5f9385f-0dfe-60cb-eca3-16aa7dbe3121@linux.intel.com>
In-Reply-To: <e5f9385f-0dfe-60cb-eca3-16aa7dbe3121@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On 12/6/2021 6:41 PM, Martinez, Ricardo wrote:
>
> On 12/1/2021 12:45 PM, Sergey Ryazanov wrote:
>> Hello Ricardo,
>>
>> On Wed, Dec 1, 2021 at 9:14 AM Martinez, Ricardo
>> <ricardo.martinez@linux.intel.com> wrote:
>>> On 11/9/2021 4:06 AM, Sergey Ryazanov wrote:
>>>> On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez wrote:
>>>>> ...
>>>>>    static struct t7xx_port md_ccci_ports[] = {
>>>>> +       {CCCI_UART2_TX, CCCI_UART2_RX, DATA_AT_CMD_Q, 
>>>>> DATA_AT_CMD_Q, 0xff,
>>>>> +        0xff, ID_CLDMA1, PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 
>>>>> 0, "ttyC0", WWAN_PORT_AT},
>>>>> +       {CCCI_MBIM_TX, CCCI_MBIM_RX, 2, 2, 0, 0, ID_CLDMA1,
>>>>> +        PORT_F_RX_CHAR_NODE, &wwan_sub_port_ops, 10, "ttyCMBIM0", 
>>>>> WWAN_PORT_MBIM},
>>>>> ...
>>>>> +               if (count + CCCI_H_ELEN > txq_mtu &&
>>>>> +                   (port_ccci->tx_ch == CCCI_MBIM_TX ||
>>>>> +                    (port_ccci->tx_ch >= CCCI_DSS0_TX && 
>>>>> port_ccci->tx_ch <= CCCI_DSS7_TX)))
>>>>> +                       multi_packet = DIV_ROUND_UP(count, txq_mtu 
>>>>> - CCCI_H_ELEN);
>>>> I am just wondering, the chip does support MBIM message fragmentation,
>>>> but does not support AT commands stream (CCCI_UART2_TX) fragmentation.
>>>> Is that the correct conclusion from the code above?
>>> Yes, that is correct.
>> Are you sure that the modem does not support AT command fragmentation?
>> The AT commands interface is a stream of chars by its nature. It is
>> designed to work over serial lines. Some modem configuration software
>> even writes commands to a port in a char-by-char manner, i.e. it
>> writes no more than one char at a time to the port.
>>
>> The mechanism that is implemented in the driver to split user input
>> into individual messages is not a true fragmentation mechanism since
>> it does not preserve the original user input length. It just cuts the
>> user input into individual messages and sends them to the modem
>> independently. So, the modem firmware has no way to distinguish
>> whether the user input has been "fragmented" by the user or the
>> driver. How, then, does the modem firmware deal with an AT command
>> "fragmented" by a user? Will the modem firmware ignore the AT command
>> that is received in the char-by-char manner?
>
> The modem supports char-by-char AT command over serial lines, I'll get 
> more information
>
> about why splitting long commands is supported only for MBIM and not 
> for AT commands.
>
The next version will allow AT command fragmentation as there is modem 
is able to handle

fragments as you pointed out. This will make the WWAN Tx callback a bit 
simpler.

