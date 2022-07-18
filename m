Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523FA577C08
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiGRG57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 02:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbiGRG5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 02:57:52 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74AF165AE;
        Sun, 17 Jul 2022 23:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1658127447;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=hmfUG42ygC3IY68mJFhKrn88/Z10OsFhm18IUnBGkWI=;
    b=Aluexo5MDAgCINr0MaS6+lyMnyA7GJ/AR2dtWFMfUW7c3WH+59rAeEE1pLqZy1JC/M
    X40Um+89T9KWdeE2RekkDFmgsEkaRUtnEUwjxDCFD972pRmZjhTuT70SlBwWBL/UnYVs
    jLxv86wXwPaSkv3up5WnK6OE6P7QfpaoWFDtB/Gktm7AOwmyMpeqSTNN6+MCLFMAPq09
    wY7fxQ/tumUapyTE2IOnt42uMzcnMZq/+jtVST+PhNT5KxcbHa5qPhzlzM9vCEf46bb1
    uHr0GFsn/rEMgY0ktmLeV1DEmgAQ4mpfOVqgDnshdgCowDXzNk674qrPsgNPqDjFP8+p
    +fzg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytJSr63tDxrw=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d100::b82]
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id t870d5y6I6vRC3c
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 18 Jul 2022 08:57:27 +0200 (CEST)
Message-ID: <6faf29c7-3e9d-bc21-9eac-710f901085d8@hartkopp.net>
Date:   Mon, 18 Jul 2022 08:57:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH 2/5] can: slcan: remove legacy infrastructure
Content-Language: en-US
To:     Max Staudt <max@enpas.org>,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
References: <20220716170007.2020037-1-dario.binacchi@amarulasolutions.com>
 <20220716170007.2020037-3-dario.binacchi@amarulasolutions.com>
 <20220717233842.1451e349.max@enpas.org>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220717233842.1451e349.max@enpas.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.07.22 23:38, Max Staudt wrote:
> Hi Dario,
> 
> This looks good, thank you for continuing to look after slcan!
> 
> A few comments below.
> 
> 
> 
> On Sat, 16 Jul 2022 19:00:04 +0200
> Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:
> 
> [...]
> 
> 
>> @@ -68,7 +62,6 @@ MODULE_PARM_DESC(maxdev, "Maximum number of slcan interfaces");
>>   				   SLC_STATE_BE_TXCNT_LEN)
>>   struct slcan {
>>   	struct can_priv         can;
>> -	int			magic;
>>   
>>   	/* Various fields. */
>>   	struct tty_struct	*tty;		/* ptr to TTY structure	     */
>> @@ -84,17 +77,14 @@ struct slcan {
>>   	int			xleft;          /* bytes left in XMIT queue  */
>>   
>>   	unsigned long		flags;		/* Flag values/ mode etc     */
>> -#define SLF_INUSE		0		/* Channel in use            */
>> -#define SLF_ERROR		1               /* Parity, etc. error        */
>> -#define SLF_XCMD		2               /* Command transmission      */
>> +#define SLF_ERROR		0               /* Parity, etc. error        */
>> +#define SLF_XCMD		1               /* Command transmission      */
>>   	unsigned long           cmd_flags;      /* Command flags             */
>>   #define CF_ERR_RST		0               /* Reset errors on open      */
>>   	wait_queue_head_t       xcmd_wait;      /* Wait queue for commands   */
> 
> I assume xcmd_wait() came in as part of the previous patch series?
> 
> 
> [...]
> 
> 
>>   /* Send a can_frame to a TTY queue. */
>> @@ -652,25 +637,21 @@ static int slc_close(struct net_device *dev)
>>   	struct slcan *sl = netdev_priv(dev);
>>   	int err;
>>   
>> -	spin_lock_bh(&sl->lock);
>> -	if (sl->tty) {
>> -		if (sl->can.bittiming.bitrate &&
>> -		    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
>> -			spin_unlock_bh(&sl->lock);
>> -			err = slcan_transmit_cmd(sl, "C\r");
>> -			spin_lock_bh(&sl->lock);
>> -			if (err)
>> -				netdev_warn(dev,
>> -					    "failed to send close command 'C\\r'\n");
>> -		}
>> -
>> -		/* TTY discipline is running. */
>> -		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>> +	if (sl->can.bittiming.bitrate &&
>> +	    sl->can.bittiming.bitrate != CAN_BITRATE_UNKNOWN) {
>> +		err = slcan_transmit_cmd(sl, "C\r");
>> +		if (err)
>> +			netdev_warn(dev,
>> +				    "failed to send close command 'C\\r'\n");
>>   	}
>> +
>> +	/* TTY discipline is running. */
>> +	clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
>> +	flush_work(&sl->tx_work);
>> +
>>   	netif_stop_queue(dev);
>>   	sl->rcount   = 0;
>>   	sl->xleft    = 0;
> 
> I suggest moving these two assignments to slc_open() - see below.
> 
> 
> [...]
> 
> 
>> @@ -883,72 +786,50 @@ static int slcan_open(struct tty_struct *tty)
>>   	if (!tty->ops->write)
>>   		return -EOPNOTSUPP;
>>   
>> -	/* RTnetlink lock is misused here to serialize concurrent
>> -	 * opens of slcan channels. There are better ways, but it is
>> -	 * the simplest one.
>> -	 */
>> -	rtnl_lock();
>> +	dev = alloc_candev(sizeof(*sl), 1);
>> +	if (!dev)
>> +		return -ENFILE;
>>   
>> -	/* Collect hanged up channels. */
>> -	slc_sync();
>> +	sl = netdev_priv(dev);
>>   
>> -	sl = tty->disc_data;
>> +	/* Configure TTY interface */
>> +	tty->receive_room = 65536; /* We don't flow control */
>> +	sl->rcount   = 0;
>> +	sl->xleft    = 0;
> 
> I suggest moving the zeroing to slc_open() - i.e. to the netdev open
> function. As a bonus, you can then remove the same two assignments from
> slc_close() (see above). They are only used when netif_running(), with
> appropiate guards already in place as far as I can see.
> 
> 
>> +	spin_lock_init(&sl->lock);
>> +	INIT_WORK(&sl->tx_work, slcan_transmit);
>> +	init_waitqueue_head(&sl->xcmd_wait);
>>   
>> -	err = -EEXIST;
>> -	/* First make sure we're not already connected. */
>> -	if (sl && sl->magic == SLCAN_MAGIC)
>> -		goto err_exit;
>> +	/* Configure CAN metadata */
>> +	sl->can.bitrate_const = slcan_bitrate_const;
>> +	sl->can.bitrate_const_cnt = ARRAY_SIZE(slcan_bitrate_const);
>>   
>> -	/* OK.  Find a free SLCAN channel to use. */
>> -	err = -ENFILE;
>> -	sl = slc_alloc();
>> -	if (!sl)
>> -		goto err_exit;
>> +	/* Configure netdev interface */
>> +	sl->dev	= dev;
>> +	strscpy(dev->name, "slcan%d", sizeof(dev->name));
> 
> The third parameter looks... unintentional :)
> 
> What do the maintainers think of dropping the old "slcan" name, and
> just allowing this to be a normal canX device? These patches do bring
> it closer to that, after all. In this case, this name string magic
> could be dropped altogether.
> 

I'm fine with it in general. But we have to take into account that there 
might be existing setups that still might use the slcan_attach or slcand 
mechanic which will likely break after the kernel update.

But in the end the slcan0 shows up everywhere - even in log files, etc.

So we really should name it canX. When people really get in trouble with 
it, they can rename the network interface name with the 'ip' tool ...

Best regards,
Oliver

> 
> [...]
> 
> 
> 
> This looks good to me overall.
> 
> Thanks Dario!
> 
> 
> Max
