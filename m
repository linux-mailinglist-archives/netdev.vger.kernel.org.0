Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15B131BC5C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBOP0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:26:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51260 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhBOP0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:26:24 -0500
Received: from 1.general.ppisati.uk.vpn ([10.172.193.134] helo=canonical.com)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <paolo.pisati@canonical.com>)
        id 1lBfkp-00032R-9L; Mon, 15 Feb 2021 15:25:39 +0000
Date:   Mon, 15 Feb 2021 16:25:38 +0100
From:   Paolo Pisati <paolo.pisati@canonical.com>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: selftests: tls: multi_chunk_sendfile: Test terminated by timeout
 (constant failure)
Message-ID: <20210215152538.GA37512@harukaze>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pooja,

commit 0e6fbe39bdf71b4e665767bcbf53567a3e6d0623
Author: Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Fri Jun 5 16:01:18 2020 +0000

    net/tls(TLS_SW): Add selftest for 'chunked' sendfile test

your multi_chunk_sendfile test is constantly failing for me (x86_64 defconfig +
tools/testing/selftests/net/config + TLS) on 5.10.y:

...
#  RUN           tls.12.multi_chunk_sendfile ...                                                                                                        
# multi_chunk_sendfile: Test terminated by timeout                                                                                                      
#          FAIL  tls.12.multi_chunk_sendfile
not ok 6 tls.12.multi_chunk_sendfile
...
#  RUN           tls.13.multi_chunk_sendfile ...
# multi_chunk_sendfile: Test terminated by timeout                          
#          FAIL  tls.13.multi_chunk_sendfile                                
not ok 51 tls.13.multi_chunk_sendfile

i tried bumping up the timeout to an insane value, but that didn't change the
outcome - anything particular i should check?
-- 
bye,
p.
