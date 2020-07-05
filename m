Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAAC214E7D
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 20:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGESZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 14:25:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47434 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgGESZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 14:25:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1js9KX-003ip9-9F; Sun, 05 Jul 2020 20:25:33 +0200
Date:   Sun, 5 Jul 2020 20:25:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v4 0/6] ethtool(1) cable test support
Message-ID: <20200705182533.GA886548@lunn.ch>
References: <20200701010743.730606-1-andrew@lunn.ch>
 <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200705004447.ook7vkzffa5ejb2v@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hello Andrew,
> 
> could you please test this update of netlink/desc-ethtool.c on top of
> your series? The userspace messages look as expected but I'm not sure if
> I have a device with cable test support available to test pretty
> printing of kernel messages. (And even if I do, I almost certainly won't
> have physical access to it.)

Tested-by: Andrew Lunn <andrew@lunn.ch>

/home/andrew/ethtool/ethtool --debug 0xff --cable-test-tdr lan2 first 10 last 12  
...
sending genetlink packet (56 bytes):
    msg length 56 ethool ETHTOOL_MSG_CABLE_TEST_TDR_ACT
    ETHTOOL_MSG_CABLE_TEST_TDR_ACT
        ETHTOOL_A_CABLE_TEST_TDR_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "lan2"
        ETHTOOL_A_CABLE_TEST_TDR_CFG
            ETHTOOL_A_CABLE_TEST_TDR_CFG_FIRST = 1000
            ETHTOOL_A_CABLE_TEST_TDR_CFG_LAST = 1200
----------------	------------------
|  0000000056  |	| message length |
| 00020 | R-A- |	|  type | flags  |
|  0000000002  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 1b 01 00 00  |	|  extra header  |
|00016|N-|00001|	|len |flags| type|
|00009|--|00002|	|len |flags| type|
| 6c 61 6e 32  |	|      data      |	 l a n 2
| 00 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| e8 03 00 00  |	|      data      |	        
|00008|--|00002|	|len |flags| type|
| b0 04 00 00  |	|      data      |	        
----------------	------------------
received genetlink packet (52 bytes):
    msg length 52 ethool ETHTOOL_MSG_CABLE_TEST_TDR_NTF
    ETHTOOL_MSG_CABLE_TEST_TDR_NTF
        ETHTOOL_A_CABLE_TEST_TDR_NTF_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 7
            ETHTOOL_A_HEADER_DEV_NAME = "lan2"
        ETHTOOL_A_CABLE_TEST_TDR_NTF_STATUS = 1
----------------	------------------
|  0000000052  |	| message length |
| 00020 | ---- |	|  type | flags  |
|  0000000036  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 1c 01 00 00  |	|  extra header  |
|00024|N-|00001|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| 07 00 00 00  |	|      data      |	        
|00009|--|00002|	|len |flags| type|
| 6c 61 6e 32  |	|      data      |	 l a n 2
| 00 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
----------------	------------------
Cable test TDR started for device lan2.
received genetlink packet (36 bytes):
    msg length 36 error errno=0
----------------	------------------
|  0000000036  |	| message length |
| 00002 | ---- |	|  type | flags  |
|  0000000002  |	| sequence number|
|  0000006959  |	|     port ID    |
----------------	------------------
| 00 00 00 00  |	|                |
| 38 00 00 00  |	|                |
| 14 00 05 00  |	|                |
| 02 00 00 00  |	|                |
| 00 00 00 00  |	|                |
----------------	------------------
received genetlink packet (336 bytes):
    msg length 336 ethool ETHTOOL_MSG_CABLE_TEST_TDR_NTF
    ETHTOOL_MSG_CABLE_TEST_TDR_NTF
        ETHTOOL_A_CABLE_TEST_TDR_NTF_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 7
            ETHTOOL_A_HEADER_DEV_NAME = "lan2"
        ETHTOOL_A_CABLE_TEST_TDR_NTF_STATUS = 2
        ETHTOOL_A_CABLE_TEST_TDR_NTF_NEST
            ETHTOOL_A_CABLE_TDR_NEST_PULSE
                ETHTOOL_A_CABLE_PULSE_mV = 1000
            ETHTOOL_A_CABLE_TDR_NEST_STEP
                ETHTOOL_A_CABLE_STEP_FIRST_DISTANCE = 966
                ETHTOOL_A_CABLE_STEP_LAST_DISTANCE = 1127
                ETHTOOL_A_CABLE_STEP_STEP_DISTANCE = 80
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 0
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 46
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 1
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 117
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 2
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 85
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 3
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 93
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 0
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 7
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 1
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 15
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 2
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 23
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 3
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 31
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 0
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 148
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 1
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 156
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 2
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 320
            ETHTOOL_A_CABLE_TDR_NEST_AMPLITUDE
                ETHTOOL_A_CABLE_AMPLITUDE_PAIR = 3
                ETHTOOL_A_CABLE_AMPLITUDE_mV = 39
----------------	------------------
|  0000000336  |	| message length |
| 00020 | ---- |	|  type | flags  |
|  0000000035  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 1c 01 00 00  |	|  extra header  |
|00024|N-|00001|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| 07 00 00 00  |	|      data      |	        
|00009|--|00002|	|len |flags| type|
| 6c 61 6e 32  |	|      data      |	 l a n 2
| 00 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00284|N-|00003|	|len |flags| type|
|00012|N-|00003|	|len |flags| type|
|00006|--|00001|	|len |flags| type|
| e8 03 00 00  |	|      data      |	        
|00028|N-|00001|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| c6 03 00 00  |	|      data      |	        
|00008|--|00002|	|len |flags| type|
| 67 04 00 00  |	|      data      |	 g      
|00008|--|00003|	|len |flags| type|
| 50 00 00 00  |	|      data      |	 P      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 00 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 2e 00 00 00  |	|      data      |	 .      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 75 00 00 00  |	|      data      |	 u      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 55 00 00 00  |	|      data      |	 U      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 03 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 5d 00 00 00  |	|      data      |	 ]      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 00 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 07 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 0f 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 17 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 03 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 1f 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 00 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 94 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 9c 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 40 01 00 00  |	|      data      |	 @      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 03 00 00 00  |	|      data      |	        
|00006|--|00002|	|len |flags| type|
| 27 00 00 00  |	|      data      |	 '      
----------------	------------------
Cable test TDR completed for device lan2.
TDR Pulse 1000mV
Step configuration: 9.66-11.27 meters in 0.80m steps
Pair A Amplitude   46
Pair B Amplitude  117
Pair C Amplitude   85
Pair D Amplitude   93
Pair A Amplitude    7
Pair B Amplitude   15
Pair C Amplitude   23
Pair D Amplitude   31
Pair A Amplitude  148
Pair B Amplitude  156
Pair C Amplitude  320
Pair D Amplitude   39


/home/andrew/ethtool/ethtool --debug 0xff --cable-test lan2
...
sending genetlink packet (36 bytes):
    msg length 36 ethool ETHTOOL_MSG_CABLE_TEST_ACT
    ETHTOOL_MSG_CABLE_TEST_ACT
        ETHTOOL_A_CABLE_TEST_HEADER
            ETHTOOL_A_HEADER_DEV_NAME = "lan2"
----------------	------------------
|  0000000036  |	| message length |
| 00020 | R-A- |	|  type | flags  |
|  0000000002  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 1a 01 00 00  |	|  extra header  |
|00016|N-|00001|	|len |flags| type|
|00009|--|00002|	|len |flags| type|
| 6c 61 6e 32  |	|      data      |	 l a n 2
| 00 00 00 00  |	|      data      |	        
----------------	------------------
received genetlink packet (52 bytes):
    msg length 52 ethool ETHTOOL_MSG_CABLE_TEST_NTF
    ETHTOOL_MSG_CABLE_TEST_NTF
        ETHTOOL_A_CABLE_TEST_NTF_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 7
            ETHTOOL_A_HEADER_DEV_NAME = "lan2"
        ETHTOOL_A_CABLE_TEST_NTF_STATUS = 1
----------------	------------------
|  0000000052  |	| message length |
| 00020 | ---- |	|  type | flags  |
|  0000000034  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 1b 01 00 00  |	|  extra header  |
|00024|N-|00001|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| 07 00 00 00  |	|      data      |	        
|00009|--|00002|	|len |flags| type|
| 6c 61 6e 32  |	|      data      |	 l a n 2
| 00 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
----------------	------------------
Cable test started for device lan2.
received genetlink packet (36 bytes):
    msg length 36 error errno=0
----------------	------------------
|  0000000036  |	| message length |
| 00002 | ---- |	|  type | flags  |
|  0000000002  |	| sequence number|
|  0000006949  |	|     port ID    |
----------------	------------------
| 00 00 00 00  |	|                |
| 24 00 00 00  |	|                |
| 14 00 05 00  |	|                |
| 02 00 00 00  |	|                |
| 00 00 00 00  |	|                |
----------------	------------------
received genetlink packet (216 bytes):
    msg length 216 ethool ETHTOOL_MSG_CABLE_TEST_NTF
    ETHTOOL_MSG_CABLE_TEST_NTF
        ETHTOOL_A_CABLE_TEST_NTF_HEADER
            ETHTOOL_A_HEADER_DEV_INDEX = 7
            ETHTOOL_A_HEADER_DEV_NAME = "lan2"
        ETHTOOL_A_CABLE_TEST_NTF_STATUS = 2
        ETHTOOL_A_CABLE_TEST_NTF_NEST
            ETHTOOL_A_CABLE_NEST_RESULT
                ETHTOOL_A_CABLE_RESULT_PAIR = 0
                ETHTOOL_A_CABLE_RESULT_CODE = 2
            ETHTOOL_A_CABLE_NEST_RESULT
                ETHTOOL_A_CABLE_RESULT_PAIR = 1
                ETHTOOL_A_CABLE_RESULT_CODE = 2
            ETHTOOL_A_CABLE_NEST_RESULT
                ETHTOOL_A_CABLE_RESULT_PAIR = 2
                ETHTOOL_A_CABLE_RESULT_CODE = 2
            ETHTOOL_A_CABLE_NEST_RESULT
                ETHTOOL_A_CABLE_RESULT_PAIR = 3
                ETHTOOL_A_CABLE_RESULT_CODE = 2
            ETHTOOL_A_CABLE_NEST_FAULT_LENGTH
                ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR = 0
                ETHTOOL_A_CABLE_FAULT_LENGTH_CM = 2400
            ETHTOOL_A_CABLE_NEST_FAULT_LENGTH
                ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR = 1
                ETHTOOL_A_CABLE_FAULT_LENGTH_CM = 2480
            ETHTOOL_A_CABLE_NEST_FAULT_LENGTH
                ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR = 2
                ETHTOOL_A_CABLE_FAULT_LENGTH_CM = 2400
            ETHTOOL_A_CABLE_NEST_FAULT_LENGTH
                ETHTOOL_A_CABLE_FAULT_LENGTH_PAIR = 3
                ETHTOOL_A_CABLE_FAULT_LENGTH_CM = 2400
----------------	------------------
|  0000000216  |	| message length |
| 00020 | ---- |	|  type | flags  |
|  0000000033  |	| sequence number|
|  0000000000  |	|     port ID    |
----------------	------------------
| 1b 01 00 00  |	|  extra header  |
|00024|N-|00001|	|len |flags| type|
|00008|--|00001|	|len |flags| type|
| 07 00 00 00  |	|      data      |	        
|00009|--|00002|	|len |flags| type|
| 6c 61 6e 32  |	|      data      |	 l a n 2
| 00 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00164|N-|00003|	|len |flags| type|
|00020|N-|00001|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 00 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00020|N-|00001|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00020|N-|00001|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00020|N-|00001|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 03 00 00 00  |	|      data      |	        
|00005|--|00002|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 00 00 00 00  |	|      data      |	        
|00008|--|00002|	|len |flags| type|
| 60 09 00 00  |	|      data      |	 `      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 01 00 00 00  |	|      data      |	        
|00008|--|00002|	|len |flags| type|
| b0 09 00 00  |	|      data      |	        
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 02 00 00 00  |	|      data      |	        
|00008|--|00002|	|len |flags| type|
| 60 09 00 00  |	|      data      |	 `      
|00020|N-|00002|	|len |flags| type|
|00005|--|00001|	|len |flags| type|
| 03 00 00 00  |	|      data      |	        
|00008|--|00002|	|len |flags| type|
| 60 09 00 00  |	|      data      |	 `      
----------------	------------------
Cable test completed for device lan2.
Pair A code Open Circuit
Pair B code Open Circuit
Pair C code Open Circuit
Pair D code Open Circuit
Pair A, fault length: 24.00m
Pair B, fault length: 24.80m
Pair C, fault length: 24.00m
Pair D, fault length: 24.00m

    Andrew
