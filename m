Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44865B0B7D
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiIGR3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIGR3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:29:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4994237E1;
        Wed,  7 Sep 2022 10:29:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t3so10207887ply.2;
        Wed, 07 Sep 2022 10:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=WZNMZpyF/eauipQuXO/Lbt+W4cgA4TDPwg9iv72mCSc=;
        b=WAENKmD5GUO7Gu8pUKDlUY65iW5Bv7O4OLrgMQ1/c3H2pReC6PsQYMyWmCK4TkLhuh
         TXFLUcW3eNf65aGwrZkN+nEd72rJku95CCtcejx3s88frLbryVpMERpD9j5lhTTYwYM6
         FtR3zoX/Or8aIqU3FOXHZE99JkA7A134KVTz1PdF7lSxqXLQO+JzyRAPFmDwUU0QfUs1
         fPRpAQM3vKlJ+4tKDwwJD39YWxc8NVvlc/wtPs+poca1XdIaT6wCMFqHjTAwSju8aqrB
         QjxE7JcqNTqLeuwI3zDLJfiogCxFxWIgPOAE7kjoFY+xknoxFCkxrtUpycmOcA5dxDjg
         i/OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=WZNMZpyF/eauipQuXO/Lbt+W4cgA4TDPwg9iv72mCSc=;
        b=ykfyGRQZ9WFpk8L7E3WmOx2qch13d0qWQcrAcQb4IRl2EPpa2QpMdwKMmPKFxiwYp6
         y9NpI2foIQ96H0v/CZ3eOJp/LG1WF2GLPTXmMg5Wd+ZQS/VDT2A2rzLe0EqiRmfhjk6H
         2Itzxp7urMdlhn++zt7X+DyL98k2fX9m6yKF0/oazL6ZJwGDC8sAq77kwsZBHjrh+OB5
         a+RvfUvxg9UuR+benMkhAena62uI18PzL+ynNEON+GNZ0er/2yIbCHHD4nOBsSglmYdn
         mYy+iLbYAKS6q8MMBJj5UM8mqAexoFPzZaWRWq/EgYeD51CpJ2ivSXkt6j3q96XxCSom
         2JkA==
X-Gm-Message-State: ACgBeo3aJKtDCuU1LOwd2YFpUA1a96Q3r9eY+dxcn0qyZcXd5HhI4zxO
        CvyOAMpuGnj03Qa0vvCz+ZthdMwoezK2yoFv
X-Google-Smtp-Source: AA6agR4nZIDAkir23+CZDT4FLGWnf2uCZr7DP14dD5iS4RXim07D51OkylWsFdBAjy0V6Dd3VRiLxw==
X-Received: by 2002:a17:902:b109:b0:174:fd03:8c3e with SMTP id q9-20020a170902b10900b00174fd038c3emr4802393plr.23.1662571790058;
        Wed, 07 Sep 2022 10:29:50 -0700 (PDT)
Received: from ?IPV6:2620:10d:c083:3603:1885:b229:3257:6535? ([2620:10d:c090:500::2:3e49])
        by smtp.gmail.com with ESMTPSA id p20-20020a170902e35400b001726ea1b716sm6540044plc.237.2022.09.07.10.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 10:29:49 -0700 (PDT)
Message-ID: <b1570efa-d27e-8af0-f705-2896fa615d05@gmail.com>
Date:   Wed, 7 Sep 2022 10:29:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.1.2
Subject: Re: [net-next v3 1/6] net: Documentation on QUIC kernel Tx crypto.
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, dsahern@kernel.org,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <adel.abushaev@gmail.com>
 <20220907004935.3971173-1-adel.abushaev@gmail.com>
 <20220907004935.3971173-2-adel.abushaev@gmail.com>
 <YxgSHJDAknxqEznd@debian.me>
From:   Adel Abouchaev <adel.abushaev@gmail.com>
In-Reply-To: <YxgSHJDAknxqEznd@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/6/22 8:38 PM, Bagas Sanjaya wrote:
> On Tue, Sep 06, 2022 at 05:49:30PM -0700, Adel Abouchaev wrote:
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
>> +The flow match is performed using 5 parameters: source and destination IP
>> +addresses, source and destination UDP ports and destination QUIC connection ID.
>> +Not all 5 parameters are always needed. The Tx direction matches the flow on
>> +the destination IP, port and destination connection ID, while the Rx part would
>> +later match on source IP, port and destination connection ID. This will cover
>> +multiple scenarios where the server is using SO_REUSEADDR and/or empty
>> +destination connection IDs or combination of these.
>> +
> Both Tx and Rx direction match destination connection ID. Is it right?

That is correct. The QUIC packet only carries the destination CID in its 
header.

Although the Tx direction could have an ancillary data carrying the 
source CID,

it is not required by any viable use case scenario.

Thank you for looking at the doc, I will add the documentation changes 
into the

v4 update.

>
>> +The Rx direction is not implemented in this set of patches.
>> +
>> +The connection migration scenario is not handled by the kernel code and will
>> +be handled by the user space portion of QUIC library. On the Tx direction,
>> +the new key would be installed before a packet with an updated destination is
>> +sent. On the Rx direction, the behavior will be to drop a packet if a flow is
>> +missing.
>> +
>> +For the key rotation, the behavior is to drop packets on Tx when the encryption
>> +key with matching key rotation bit is not present. On Rx direction, the packet
>> +will be sent to the userspace library with unencrypted header and encrypted
>> +payload. A separate indication will be added to the ancillary data to indicate
>> +the status of the operation as not matching the current key bit. It is not
>> +possible to use the key rotation bit as part of the key for flow lookup as that
>> +bit is protected by the header protection. A special provision will need to be
>> +done in user mode to still attempt the decryption of the payload to prevent a
>> +timing attack.
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
>> +        conn_info.conn_payload_key_gen = 0;
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
> The rest of documentation can be improved, like:
>
> ---- >8 ----
>
> diff --git a/Documentation/networking/quic.rst b/Documentation/networking/quic.rst
> index 2e6ec72f4eea3a..3f3d05b901da3f 100644
> --- a/Documentation/networking/quic.rst
> +++ b/Documentation/networking/quic.rst
> @@ -9,22 +9,22 @@ Overview
>   
>   QUIC is a secure general-purpose transport protocol that creates a stateful
>   interaction between a client and a server. QUIC provides end-to-end integrity
> -and confidentiality. Refer to RFC 9000 for more information on QUIC.
> +and confidentiality. Refer to RFC 9000 [#rfc9000]_ for the standard document.
>   
>   The kernel Tx side offload covers the encryption of the application streams
>   in the kernel rather than in the application. These packets are 1RTT packets
>   in QUIC connection. Encryption of every other packets is still done by the
> -QUIC library in user space.
> +QUIC library in userspace.
>   
>   The flow match is performed using 5 parameters: source and destination IP
>   addresses, source and destination UDP ports and destination QUIC connection ID.
> -Not all 5 parameters are always needed. The Tx direction matches the flow on
> -the destination IP, port and destination connection ID, while the Rx part would
> -later match on source IP, port and destination connection ID. This will cover
> -multiple scenarios where the server is using SO_REUSEADDR and/or empty
> -destination connection IDs or combination of these.
> +Not all these parameters are always needed. The Tx direction matches the flow
> +on the destination IP, port and destination connection ID; while the Rx
> +direction would later match on source IP, port and destination connection ID.
> +This will cover multiple scenarios where the server is using ``SO_REUSEADDR``
> +and/or empty destination connection IDs or combination of these.
>   
> -The Rx direction is not implemented in this set of patches.
> +The Rx direction is not implemented yet.
>   
>   The connection migration scenario is not handled by the kernel code and will
>   be handled by the user space portion of QUIC library. On the Tx direction,
> @@ -39,8 +39,8 @@ payload. A separate indication will be added to the ancillary data to indicate
>   the status of the operation as not matching the current key bit. It is not
>   possible to use the key rotation bit as part of the key for flow lookup as that
>   bit is protected by the header protection. A special provision will need to be
> -done in user mode to still attempt the decryption of the payload to prevent a
> -timing attack.
> +done in user mode to keep attempting the payload decription to prevent timing
> +attacks.
>   
>   
>   User Interface
> @@ -50,7 +50,7 @@ Creating a QUIC connection
>   --------------------------
>   
>   QUIC connection originates and terminates in the application, using one of many
> -available QUIC libraries. The code instantiates QUIC client and QUIC server in
> +available QUIC libraries. The code instantiates the client and server in
>   some form and configures them to use certain addresses and ports for the
>   source and destination. The client and server negotiate the set of keys to
>   protect the communication during different phases of the connection, maintain
> @@ -60,7 +60,7 @@ Requesting to add QUIC Tx kernel encryption to the connection
>   -------------------------------------------------------------
>   
>   Each flow that should be encrypted by the kernel needs to be registered with
> -the kernel using socket API. A setsockopt() call on the socket creates an
> +the kernel using socket API. A ``setsockopt()`` call on the socket creates an
>   association between the QUIC connection ID of the flow with the encryption
>   parameters for the crypto operations:
>   
> @@ -112,10 +112,10 @@ necessary to supply to remove the connection from the offload:
>   	setsockopt(fd, SOL_UDP, UDP_QUIC_DEL_TX_CONNECTION, &conn_info,
>   		   sizeof(conn_info));
>   
> -Sending QUIC application data
> ------------------------------
> +Sending application data
> +------------------------
>   
> -For QUIC Tx encryption offload, the application should use sendmsg() socket
> +For Tx encryption offload, the application should use ``sendmsg()`` socket
>   call and provide ancillary data with information on connection ID length and
>   offload flags for the kernel to perform the encryption and GSO support if
>   requested.
> @@ -168,11 +168,11 @@ Sending QUIC application data with GSO
>   --------------------------------------
>   When GSO is in use, the kernel will use the GSO fragment size as the target
>   for ciphertext. The packets from the user space should align on the boundary
> -of GSO fragment size minus the size of the tag for the chosen cipher. For the
> -GSO fragment 1200, the plain packets should follow each other at every 1184
> -bytes, given the tag size of 16. After the encryption, the rest of the UDP
> -and IP stacks will follow the defined value of GSO fragment which will include
> -the trailing tag bytes.
> +of the fragment size minus the tag size for the chosen cipher. For example,
> +if the fragment size is 1200 bytes and the tag size is 16 bytes, the plain
> +packets should follow each other at every 1184 bytes. After the encryption,
> +the rest of UDP and IP stacks will follow the defined value of the fragment,
> +which includes the trailing tag bytes.
>   
>   To set up GSO fragmentation:
>   
> @@ -181,7 +181,7 @@ To set up GSO fragmentation:
>   	setsockopt(self->sfd, SOL_UDP, UDP_SEGMENT, &frag_size,
>   		   sizeof(frag_size));
>   
> -If the GSO fragment size is provided in ancillary data within the sendmsg()
> +If the fragment size is provided in ancillary data within the ``sendmsg()``
>   call, the value in ancillary data will take precedence over the segment size
>   provided in setsockopt to split the payload into packets. This is consistent
>   with the UDP stack behavior.
> @@ -190,12 +190,10 @@ Integrating to userspace QUIC libraries
>   ---------------------------------------
>   
>   Userspace QUIC libraries integration would depend on the implementation of the
> -QUIC protocol. For MVFST library, the control plane is integrated into the
> -handshake callbacks to properly configure the flows into the socket; and the
> -data plane is integrated into the methods that perform encryption and send
> -the packets to the batch scheduler for transmissions to the socket.
> -
> -MVFST library can be found at https://github.com/facebookincubator/mvfst.
> +QUIC protocol. For MVFST library [#mvfst]_, the control plane is integrated
> +into the handshake callbacks to properly configure the flows into the socket;
> +and the data plane is integrated into the methods that perform encryption
> +and send the packets to the batch scheduler for transmissions to the socket.
>   
>   Statistics
>   ==========
> @@ -209,3 +207,9 @@ QUIC Tx offload to the kernel has counters
>     accumulative total number of offloaded QUIC connections
>   - ``QuicTxSwError`` -
>     accumulative total number of errors during QUIC Tx offload to kernel
> +
> +References
> +==========
> +
> +.. [#rfc9000] https://datatracker.ietf.org/doc/html/rfc9000
> +.. [#mvfst] https://github.com/facebookincubator/mvfst
>
> Thanks.
>
Cheers,

Adel.

