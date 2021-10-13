Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE4542CE1E
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhJMWdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbhJMWcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 18:32:46 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0374C061762
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:30:41 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id w10so1347425ilc.13
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 15:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6KWRzxS7RS7gFHwEtjqDdzgNfclWJ4qG/XJ3mOFIAP0=;
        b=d+MYhpo6ZiTH7g2UjJ/hkjxCdFhWZif8eMB0Dht4/V5NNmz1HEjsR8x9gVeS+26bC9
         0FhaYuuy9fiq8lx30VegJ/ePcZz5qBUpezeIob+oQ7DstiunNBj/lGhgK9BbRJjMhz/u
         DpcR6iVpZwDVb0CQ2VyhTZOdXugQAm5AwG0zI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6KWRzxS7RS7gFHwEtjqDdzgNfclWJ4qG/XJ3mOFIAP0=;
        b=mOUoVJ9KiCF96dJ3RekPUZDC1KAncieWfCNh0pC3oKQVvI7BNy6kGdTK6suGP2NTYb
         Km7L0FP41+keRA5m+zeghFd5mnmTrfloaCaR09E+UKHWZqlfI2nrPnHkNMJHZH5EGKQa
         lMyUHaSi9igL3Vqz/Q/j7OABvjux0N2linn9b+R943H559dGl8RRC0lHNhQk1WU1w4LU
         K0rx9ma/5S/3i3CyBXHuOgUHejfs8rrHqQQT9ZBj66kr5zqvKaE8vZeBDtXb7WichBBP
         pbdtvCWjIrGUYDrGOH9YhSkVLtVkLBNVv+ymcNkeWSHTGYVum6DUHiE6PQJKfX8/hKn3
         OJIw==
X-Gm-Message-State: AOAM532GuU+TIKlJVtTl0LKM+d+J1ZqZyTTgo1qyTvPYicugIr0p7P6V
        tJo4KcX8TXBiz4sReqTGrptY2w==
X-Google-Smtp-Source: ABdhPJzWGm64Wq8hXXz3sdVXA85HPc+8mYJCDwh1Z9frlGoNMSgAaEMkjNcOhjS9Quw13FvMy7Tp5w==
X-Received: by 2002:a05:6e02:1808:: with SMTP id a8mr1342785ilv.217.1634164241359;
        Wed, 13 Oct 2021 15:30:41 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i125sm363180iof.7.2021.10.13.15.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 15:30:40 -0700 (PDT)
Subject: Re: [RFC PATCH 14/17] net: ipa: Add support for IPA v2
 microcontroller
To:     Sireesh Kodali <sireeshkodali1@gmail.com>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, elder@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210920030811.57273-1-sireeshkodali1@gmail.com>
 <20210920030811.57273-15-sireeshkodali1@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <1317bce4-60d4-b502-0792-ad57b56f2280@ieee.org>
Date:   Wed, 13 Oct 2021 17:30:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210920030811.57273-15-sireeshkodali1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> There are some minor differences between IPA v2.x and later revisions
> with regards to the uc. The biggeset difference is the shared memory's
> layout. There are also some changes to the command numbers, but these
> are not too important, since the mainline driver doesn't use them.

It's a shame that so much has to be rearranged when the
structure definitions are changed.  If I spent more time
thinking about this I might suggest a different way of
abstracting the two, but for now this looks fine.

					-Alex


> Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> ---
>   drivers/net/ipa/ipa_uc.c | 96 ++++++++++++++++++++++++++--------------
>   1 file changed, 63 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
> index 856e55a080a7..bf6b25098301 100644
> --- a/drivers/net/ipa/ipa_uc.c
> +++ b/drivers/net/ipa/ipa_uc.c
> @@ -39,11 +39,12 @@
>   #define IPA_SEND_DELAY		100	/* microseconds */
>   
>   /**
> - * struct ipa_uc_mem_area - AP/microcontroller shared memory area
> + * union ipa_uc_mem_area - AP/microcontroller shared memory area
>    * @command:		command code (AP->microcontroller)
>    * @reserved0:		reserved bytes; avoid reading or writing
>    * @command_param:	low 32 bits of command parameter (AP->microcontroller)
>    * @command_param_hi:	high 32 bits of command parameter (AP->microcontroller)
> + *			Available since IPA v3.0
>    *
>    * @response:		response code (microcontroller->AP)
>    * @reserved1:		reserved bytes; avoid reading or writing
> @@ -59,31 +60,58 @@
>    * @reserved3:		reserved bytes; avoid reading or writing
>    * @interface_version:	hardware-reported interface version
>    * @reserved4:		reserved bytes; avoid reading or writing
> + * @reserved5:		reserved bytes; avoid reading or writing
>    *
>    * A shared memory area at the base of IPA resident memory is used for
>    * communication with the microcontroller.  The region is 128 bytes in
>    * size, but only the first 40 bytes (structured this way) are used.
>    */
> -struct ipa_uc_mem_area {
> -	u8 command;		/* enum ipa_uc_command */
> -	u8 reserved0[3];
> -	__le32 command_param;
> -	__le32 command_param_hi;
> -	u8 response;		/* enum ipa_uc_response */
> -	u8 reserved1[3];
> -	__le32 response_param;
> -	u8 event;		/* enum ipa_uc_event */
> -	u8 reserved2[3];
> -
> -	__le32 event_param;
> -	__le32 first_error_address;
> -	u8 hw_state;
> -	u8 warning_counter;
> -	__le16 reserved3;
> -	__le16 interface_version;
> -	__le16 reserved4;
> +union ipa_uc_mem_area {
> +	struct {
> +		u8 command;		/* enum ipa_uc_command */
> +		u8 reserved0[3];
> +		__le32 command_param;
> +		u8 response;		/* enum ipa_uc_response */
> +		u8 reserved1[3];
> +		__le32 response_param;
> +		u8 event;		/* enum ipa_uc_event */
> +		u8 reserved2[3];
> +
> +		__le32 event_param;
> +		__le32 reserved3;
> +		__le32 first_error_address;
> +		u8 hw_state;
> +		u8 warning_counter;
> +		__le16 reserved4;
> +		__le16 interface_version;
> +		__le16 reserved5;
> +	} v2;
> +	struct {
> +		u8 command;		/* enum ipa_uc_command */
> +		u8 reserved0[3];
> +		__le32 command_param;
> +		__le32 command_param_hi;
> +		u8 response;		/* enum ipa_uc_response */
> +		u8 reserved1[3];
> +		__le32 response_param;
> +		u8 event;		/* enum ipa_uc_event */
> +		u8 reserved2[3];
> +
> +		__le32 event_param;
> +		__le32 first_error_address;
> +		u8 hw_state;
> +		u8 warning_counter;
> +		__le16 reserved3;
> +		__le16 interface_version;
> +		__le16 reserved4;
> +	} v3;
>   };
>   
> +#define UC_FIELD(_ipa, _field)			\
> +	*((_ipa->version >= IPA_VERSION_3_0) ?	\
> +	  &(ipa_uc_shared(_ipa)->v3._field) :	\
> +	  &(ipa_uc_shared(_ipa)->v2._field))
> +
>   /** enum ipa_uc_command - commands from the AP to the microcontroller */
>   enum ipa_uc_command {
>   	IPA_UC_COMMAND_NO_OP		= 0x0,
> @@ -95,6 +123,7 @@ enum ipa_uc_command {
>   	IPA_UC_COMMAND_CLK_UNGATE	= 0x6,
>   	IPA_UC_COMMAND_MEMCPY		= 0x7,
>   	IPA_UC_COMMAND_RESET_PIPE	= 0x8,
> +	/* Next two commands are present for IPA v3.0+ */
>   	IPA_UC_COMMAND_REG_WRITE	= 0x9,
>   	IPA_UC_COMMAND_GSI_CH_EMPTY	= 0xa,
>   };
> @@ -114,7 +143,7 @@ enum ipa_uc_event {
>   	IPA_UC_EVENT_LOG_INFO		= 0x2,
>   };
>   
> -static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
> +static union ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
>   {
>   	const struct ipa_mem *mem = ipa_mem_find(ipa, IPA_MEM_UC_SHARED);
>   	u32 offset = ipa->mem_offset + mem->offset;
> @@ -125,22 +154,22 @@ static struct ipa_uc_mem_area *ipa_uc_shared(struct ipa *ipa)
>   /* Microcontroller event IPA interrupt handler */
>   static void ipa_uc_event_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
>   {
> -	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
>   	struct device *dev = &ipa->pdev->dev;
> +	u32 event = UC_FIELD(ipa, event);
>   
> -	if (shared->event == IPA_UC_EVENT_ERROR)
> +	if (event == IPA_UC_EVENT_ERROR)
>   		dev_err(dev, "microcontroller error event\n");
> -	else if (shared->event != IPA_UC_EVENT_LOG_INFO)
> +	else if (event != IPA_UC_EVENT_LOG_INFO)
>   		dev_err(dev, "unsupported microcontroller event %u\n",
> -			shared->event);
> +			event);
>   	/* The LOG_INFO event can be safely ignored */
>   }
>   
>   /* Microcontroller response IPA interrupt handler */
>   static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
>   {
> -	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
>   	struct device *dev = &ipa->pdev->dev;
> +	u32 response = UC_FIELD(ipa, response);
>   
>   	/* An INIT_COMPLETED response message is sent to the AP by the
>   	 * microcontroller when it is operational.  Other than this, the AP
> @@ -150,20 +179,21 @@ static void ipa_uc_response_hdlr(struct ipa *ipa, enum ipa_irq_id irq_id)
>   	 * We can drop the power reference taken in ipa_uc_power() once we
>   	 * know the microcontroller has finished its initialization.
>   	 */
> -	switch (shared->response) {
> +	switch (response) {
>   	case IPA_UC_RESPONSE_INIT_COMPLETED:
>   		if (ipa->uc_powered) {
>   			ipa->uc_loaded = true;
>   			pm_runtime_mark_last_busy(dev);
>   			(void)pm_runtime_put_autosuspend(dev);
>   			ipa->uc_powered = false;
> +			ipa_qmi_signal_uc_loaded(ipa);
>   		} else {
>   			dev_warn(dev, "unexpected init_completed response\n");
>   		}
>   		break;
>   	default:
>   		dev_warn(dev, "unsupported microcontroller response %u\n",
> -			 shared->response);
> +			 response);
>   		break;
>   	}
>   }
> @@ -216,16 +246,16 @@ void ipa_uc_power(struct ipa *ipa)
>   /* Send a command to the microcontroller */
>   static void send_uc_command(struct ipa *ipa, u32 command, u32 command_param)
>   {
> -	struct ipa_uc_mem_area *shared = ipa_uc_shared(ipa);
>   	u32 offset;
>   	u32 val;
>   
>   	/* Fill in the command data */
> -	shared->command = command;
> -	shared->command_param = cpu_to_le32(command_param);
> -	shared->command_param_hi = 0;
> -	shared->response = 0;
> -	shared->response_param = 0;
> +	UC_FIELD(ipa, command) = command;
> +	UC_FIELD(ipa, command_param) = cpu_to_le32(command_param);
> +	if (ipa->version >= IPA_VERSION_3_0)
> +		ipa_uc_shared(ipa)->v3.command_param_hi = 1;
> +	UC_FIELD(ipa, response) = 0;
> +	UC_FIELD(ipa, response_param) = 0;
>   
>   	/* Use an interrupt to tell the microcontroller the command is ready */
>   	val = u32_encode_bits(1, UC_INTR_FMASK);
> 

