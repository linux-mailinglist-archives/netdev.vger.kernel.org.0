Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D6958CE45
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244181AbiHHTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiHHTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:05:07 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE67A473;
        Mon,  8 Aug 2022 12:05:04 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c24so4528918pgg.11;
        Mon, 08 Aug 2022 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=bqzZknWZx8mYrqqJwFyD4G/xhi3NYM4Tt8vviY2t9qU=;
        b=TwY85Fv1lXAHCobRF3tsAO5HN9S5NNI0VPD3CUXrxauf2nXsv+B70iFISutjzkIliZ
         nGPAvniREpq7ga0vKE9Ba2k/gREJFMrFMYK3eVoQfeoYm35IOoUFjjEm7/Y5u9veTznl
         UrO+FEPHwkZfjUd6DOAX8dxaI9DJbhh3LlPK9ZBWUYTi5EZrjZkSmxufu94gWvoYU0gA
         GghFZihuF5oXlnj+iP/Y6Fhc+qGHpK8WqcQaK7bAjK3+45u0QqW2qPafszcHuoLWL5J5
         UELGa8v9yLo/QQhWV58lM5g14Od29BKqJ14azMTex9lkjiQdvqtXdez7woyK2hIXBG/R
         Ow1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=bqzZknWZx8mYrqqJwFyD4G/xhi3NYM4Tt8vviY2t9qU=;
        b=TYHP8CcgbHxto6/Ar4XKX1Nz6iixHjDxX7niIvL5kk68YZnCSFgXwNEFqIx801kDHj
         x9eBvCmSEXjSmR0ZZMhO9++BYsWLPyTYPvEACbBWyfM6ZE4sN3fpLoXzLYAJtz++Q2pl
         nzvmh983WJvmOqcZNsLgMMJ53+CBYH1f5dhLA/3/eBWGSTAN17c52+XcJY6jMUzleOBS
         /t/H5re36KuUGLsDHP/qldniw81VU+tdcnPp0939wKCF9ynmTQijXqgXqutBGkQUuWu3
         LyrhmkMZi0wqvY5Olix5AEQdCUwMWNSxZ/GWGnP6PFnMWCH1x2prLst/yJqIOtyIiHUT
         ONlQ==
X-Gm-Message-State: ACgBeo00tXuh3KDN/qvnINFKn7Gdj6wVXLRewBG1LtAk7KHjih2qb6Pa
        Z7Lm7DHYQvMj363xVfT0kEi6fxN+DMyolwd+
X-Google-Smtp-Source: AA6agR4pgLTfE6pk3s5PUjRdFlznozEMVbIfGVhBiOmanwJrE/aQFd43RvBLolucAPi0dEmT5kt84w==
X-Received: by 2002:a63:e616:0:b0:41b:8f2c:1065 with SMTP id g22-20020a63e616000000b0041b8f2c1065mr16312216pgh.244.1659985503938;
        Mon, 08 Aug 2022 12:05:03 -0700 (PDT)
Received: from ?IPV6:2620:10d:c083:3603:1885:b229:3257:6535? ([2620:10d:c090:500::3:1ef1])
        by smtp.gmail.com with ESMTPSA id c7-20020a170903234700b0016a7b9558f7sm9197823plh.136.2022.08.08.12.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 12:05:03 -0700 (PDT)
Message-ID: <97789971-7cf5-ede1-11e2-df6494e75e44@gmail.com>
Date:   Mon, 8 Aug 2022 12:05:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.0
Subject: Re: [RFC net-next v2 1/6] Documentation on QUIC kernel Tx crypto.
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <adel.abushaev@gmail.com>
 <20220806001153.1461577-1-adel.abushaev@gmail.com>
 <20220806001153.1461577-2-adel.abushaev@gmail.com>
 <Yu3acQf/xS6g/bdH@debian.me>
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <Yu3acQf/xS6g/bdH@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated the commit message, will be visible in v3.

On 8/5/22 8:05 PM, Bagas Sanjaya wrote:
> On Fri, Aug 05, 2022 at 05:11:48PM -0700, Adel Abouchaev wrote:
>> Adding Documentation/networking/quic.rst file to describe kernel QUIC
>> code.
>>
> Better say "Add documentation for kernel QUIC code".
>
>> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
>> index 03b215bddde8..656fa1dac26b 100644
>> --- a/Documentation/networking/index.rst
>> +++ b/Documentation/networking/index.rst
>> @@ -90,6 +90,7 @@ Contents:
>>      plip
>>      ppp_generic
>>      proc_net_tcp
>> +   quic
>>      radiotap-headers
>>      rds
>>      regulatory
>> diff --git a/Documentation/networking/quic.rst b/Documentation/networking/quic.rst
>> new file mode 100644
>> index 000000000000..416099b80e60
>> --- /dev/null
>> +++ b/Documentation/networking/quic.rst
>> @@ -0,0 +1,186 @@
>> +.. _kernel_quic:
>> +
>> +===========
>> +KERNEL QUIC
>> +===========
>> +
>> +Overview
>> +========
>> +
>> +QUIC is a secure general-purpose transport protocol that creates a stateful
>> +interaction between a client and a server. QUIC provides end-to-end integrity
>> +and confidentiality. Refer to RFC 9000 for more information on QUIC.
>> +
>> +The kernel Tx side offload covers the encryption of the application streams
>> +in the kernel rather than in the application. These packets are 1RTT packets
>> +in QUIC connection. Encryption of every other packets is still done by the
>> +QUIC library in user space.
>> +
>> +
>> +
>> +User Interface
>> +==============
>> +
>> +Creating a QUIC connection
>> +--------------------------
>> +
>> +QUIC connection originates and terminates in the application, using one of many
>> +available QUIC libraries. The code instantiates QUIC client and QUIC server in
>> +some form and configures them to use certain addresses and ports for the
>> +source and destination. The client and server negotiate the set of keys to
>> +protect the communication during different phases of the connection, maintain
>> +the connection and perform congestion control.
>> +
>> +Requesting to add QUIC Tx kernel encryption to the connection
>> +-------------------------------------------------------------
>> +
>> +Each flow that should be encrypted by the kernel needs to be registered with
>> +the kernel using socket API. A setsockopt() call on the socket creates an
>> +association between the QUIC connection ID of the flow with the encryption
>> +parameters for the crypto operations:
>> +
>> +.. code-block:: c
>> +
>> +	struct quic_connection_info conn_info;
>> +	char conn_id[5] = {0x01, 0x02, 0x03, 0x04, 0x05};
>> +	const size_t conn_id_len = sizeof(conn_id);
>> +	char conn_key[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
>> +			     0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
>> +	char conn_iv[12] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
>> +			    0x08, 0x09, 0x0a, 0x0b};
>> +	char conn_hdr_key[16] = {0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
>> +				 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f
>> +				};
>> +
>> +	conn_info.cipher_type = TLS_CIPHER_AES_GCM_128;
>> +
>> +	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
>> +	conn_info.key.conn_id_length = 5;
>> +	memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE
>> +				      - conn_id_len],
>> +	       &conn_id, conn_id_len);
>> +
>> +	memcpy(&conn_info.payload_key, conn_key, sizeof(conn_key));
>> +	memcpy(&conn_info.payload_iv, conn_iv, sizeof(conn_iv));
>> +	memcpy(&conn_info.header_key, conn_hdr_key, sizeof(conn_hdr_key));
>> +
>> +	setsockopt(fd, SOL_UDP, UDP_QUIC_ADD_TX_CONNECTION, &conn_info,
>> +		   sizeof(conn_info));
>> +
>> +
>> +Requesting to remove QUIC Tx kernel crypto offload control messages
>> +-------------------------------------------------------------------
>> +
>> +All flows are removed when the socket is closed. To request an explicit remove
>> +of the offload for the connection during the lifetime of the socket the process
>> +is similar to adding the flow. Only the connection ID and its length are
>> +necessary to supply to remove the connection from the offload:
>> +
>> +.. code-block:: c
>> +
>> +	memset(&conn_info.key, 0, sizeof(struct quic_connection_info_key));
>> +	conn_info.key.conn_id_length = 5;
>> +	memcpy(&conn_info.key.conn_id[QUIC_MAX_CONNECTION_ID_SIZE
>> +				      - conn_id_len],
>> +	       &conn_id, conn_id_len);
>> +	setsockopt(fd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION, &conn_info,
>> +		   sizeof(conn_info));
>> +
>> +Sending QUIC application data
>> +-----------------------------
>> +
>> +For QUIC Tx encryption offload, the application should use sendmsg() socket
>> +call and provide ancillary data with information on connection ID length and
>> +offload flags for the kernel to perform the encryption and GSO support if
>> +requested.
>> +
>> +.. code-block:: c
>> +
>> +	size_t cmsg_tx_len = sizeof(struct quic_tx_ancillary_data);
>> +	uint8_t cmsg_buf[CMSG_SPACE(cmsg_tx_len)];
>> +	struct quic_tx_ancillary_data * anc_data;
>> +	size_t quic_data_len = 4500;
>> +	struct cmsghdr * cmsg_hdr;
>> +	char quic_data[9000];
>> +	struct iovec iov[2];
>> +	int send_len = 9000;
>> +	struct msghdr msg;
>> +	int err;
>> +
>> +	iov[0].iov_base = quic_data;
>> +	iov[0].iov_len = quic_data_len;
>> +	iov[1].iov_base = quic_data + 4500;
>> +	iov[1].iov_len = quic_data_len;
>> +
>> +	if (client.addr.sin_family == AF_INET) {
>> +		msg.msg_name = &client.addr;
>> +		msg.msg_namelen = sizeof(client.addr);
>> +	} else {
>> +		msg.msg_name = &client.addr6;
>> +		msg.msg_namelen = sizeof(client.addr6);
>> +	}
>> +
>> +	msg.msg_iov = iov;
>> +	msg.msg_iovlen = 2;
>> +	msg.msg_control = cmsg_buf;
>> +	msg.msg_controllen = sizeof(cmsg_buf);
>> +	cmsg_hdr = CMSG_FIRSTHDR(&msg);
>> +	cmsg_hdr->cmsg_level = IPPROTO_UDP;
>> +	cmsg_hdr->cmsg_type = UDP_QUIC_ENCRYPT;
>> +	cmsg_hdr->cmsg_len = CMSG_LEN(cmsg_tx_len);
>> +	anc_data = CMSG_DATA(cmsg_hdr);
>> +	anc_data->flags = 0;
>> +	anc_data->next_pkt_num = 0x0d65c9;
>> +	anc_data->conn_id_length = conn_id_len;
>> +	err = sendmsg(self->sfd, &msg, 0);
>> +
>> +QUIC Tx offload in kernel will read the data from userspace, encrypt and
>> +copy it to the ciphertext within the same operation.
>> +
>> +
>> +Sending QUIC application data with GSO
>> +--------------------------------------
>> +When GSO is in use, the kernel will use the GSO fragment size as the target
>> +for ciphertext. The packets from the user space should align on the boundary
>> +of GSO fragment size minus the size of the tag for the chosen cipher. For the
>> +GSO fragment 1200, the plain packets should follow each other at every 1184
>> +bytes, given the tag size of 16. After the encryption, the rest of the UDP
>> +and IP stacks will follow the defined value of GSO fragment which will include
>> +the trailing tag bytes.
>> +
>> +To set up GSO fragmentation:
>> +
>> +.. code-block:: c
>> +
>> +	setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
>> +		   sizeof(frag_size));
>> +
>> +If the GSO fragment size is provided in ancillary data within the sendmsg()
>> +call, the value in ancillary data will take precedence over the segment size
>> +provided in setsockopt to split the payload into packets. This is consistent
>> +with the UDP stack behavior.
>> +
>> +Integrating to userspace QUIC libraries
>> +---------------------------------------
>> +
>> +Userspace QUIC libraries integration would depend on the implementation of the
>> +QUIC protocol. For MVFST library, the control plane is integrated into the
>> +handshake callbacks to properly configure the flows into the socket; and the
>> +data plane is integrated into the methods that perform encryption and send
>> +the packets to the batch scheduler for transmissions to the socket.
>> +
>> +MVFST library can be found at https://github.com/facebookincubator/mvfst.
>> +
>> +Statistics
>> +==========
>> +
>> +QUIC Tx offload to the kernel has counters
>> +(``/proc/net/quic_stat``):
>> +
>> +- ``QuicCurrTxSw`` -
>> +  number of currently active kernel offloaded QUIC connections
>> +- ``QuicTxSw`` -
>> +  accumulative total number of offloaded QUIC connections
>> +- ``QuicTxSwError`` -
>> +  accumulative total number of errors during QUIC Tx offload to kernel
>> +
> The documentation looks OK (no new warnings).
>
> Thanks.
>
