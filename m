Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE17F75BB
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfKKNzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:55:24 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38897 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbfKKNzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:55:24 -0500
Received: from [192.168.2.10] ([46.9.232.237])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UA9fiVFfsQBsYUA9ki6cYM; Mon, 11 Nov 2019 14:55:18 +0100
Subject: Re: WARNING in dma_buf_vunmap
To:     syzbot <syzbot+a9317fe7ad261fc76b88@syzkaller.appspotmail.com>,
        andy@greyhouse.net, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        j.vosburgh@gmail.com, kyungmin.park@samsung.com,
        linaro-mm-sig-owner@lists.linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        maheshb@google.com, mchehab+samsung@kernel.org, mchehab@kernel.org,
        netdev@vger.kernel.org, pawel@osciak.com, sumit.semwal@linaro.org,
        syzkaller-bugs@googlegroups.com, tfiga@chromium.org,
        vfalico@gmail.com
References: <000000000000d2c94e0596c1d47b@google.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <5ed667c7-36ee-466c-7f6d-cd52ccb71c28@xs4all.nl>
Date:   Mon, 11 Nov 2019 14:54:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <000000000000d2c94e0596c1d47b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOVyIXaOdZqyrZFAcLrvkaNOhPcmisjimCJz25F9XwmH9nD5lWqPr+Wf1+q27L8QJeRigdxxQPwscLrsW01Py/OJfmCjP6ls8p7ZDuOLtAyj6LtYfqLk
 AGRud3HQKuid40ueqTwCHVZluw0DxJ4VCYZI5TOBG06jns6XG0xc4cCKVQeiZ5LW6sIY14VK9AUSjSSwPdwAYNrBVlU6u4UUhb7+vY1jcwy5zHGHGD62hHDX
 1aMHRhXeUCtUmVi6U/6rKqXY4/aOgyChPds2EMDB5CRUX9FmoAw9NKkwVF5Vl354yBFw2J/TF3mj1nOXFRApFc4tck43MoqHD3Vck0FekoeF4cqBjCOmAo+r
 1Hbxl0GcagIo0Rnsu0SKz8KvFBWY1f0V/XQpgk1Jd+zuzdDtECNNuD1EaOzqtXnnBzjCc6RWZaPoOVRuErgusCtdnLWvDpeN5H2YpoyMhvZoubK0Lj96TzZ7
 MB7n5u6rCAzB/XbpaldT4dUTqj7eQBVElUCg71RpVuet68YMPNbvPaM9e2vB092mqgUQRG4ufzJ61GHsGKhQn54duhF/7Ve23frFlgwcxN5pdPEpeU+sT5ix
 DzIunwN828xBm6v7P/W5A/PQa50xNq2hdKND0Qxxc/K/RgR9C11emf5X4FBn1gUWdvzAhuxYE9+adGq2wGUOC5+lUFqRXfTavXd6CBSPftfMf3LF9MngJOlI
 xAK9gMhtdlJsJPZspCDsPfQVWn6U+Wn9mNEikBsXTBLDjbeGI0TTgtetuSNuahWHEl9LLGOHi2333/yekdP03Pysh23Mt7HCUE5/cDQHMUatEkqZNw3Ucc1K
 iOV3ggiTx5oK46cuTRt1qg0FTx96jylWsG0PNnGhU2lDyMCElFc55pf/6MoChq8dKuAtWGED+fkTRREvoWLp+TvXMEhOwG9rPpXLK4XjoyrrJDIOdyX01o6m
 8MjInQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: media: vb2: check memory model for VIDIOC_CREATE_BUFS

