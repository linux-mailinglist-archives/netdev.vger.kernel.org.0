Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6371469F02
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 00:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731510AbfGOWhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 18:37:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:36690 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731167AbfGOWhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 18:37:22 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9KS-0001tS-MJ; Tue, 16 Jul 2019 00:20:16 +0200
Received: from [99.0.85.34] (helo=localhost.localdomain)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hn9KS-000Oad-9x; Tue, 16 Jul 2019 00:20:16 +0200
Subject: Re: [PATCH bpf] selftests/bpf: put test_stub.o into $(OUTPUT)
To:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com
References: <20190712135950.91600-1-iii@linux.ibm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <79694e9f-d479-9dd8-81e4-a110d54b532d@iogearbox.net>
Date:   Tue, 16 Jul 2019 00:20:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190712135950.91600-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25511/Mon Jul 15 10:10:35 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 3:59 PM, Ilya Leoshkevich wrote:
> Add a rule to put test_stub.o in $(OUTPUT) and change the references to
> it accordingly. This prevents test_stub.o from being created in the
> source directory.
> 
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied, thanks!
