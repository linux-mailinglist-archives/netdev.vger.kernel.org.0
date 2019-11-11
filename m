Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF8AF75D3
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 15:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKOBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 09:01:09 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41951 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbfKKOBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 09:01:09 -0500
Received: from [192.168.2.10] ([46.9.232.237])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UAFViVIMgQBsYUAFYi6fAY; Mon, 11 Nov 2019 15:01:07 +0100
Subject: Re: INFO: task hung in vivid_stop_generating_vid_cap
To:     syzbot <syzbot+06283a66a648cd073885@syzkaller.appspotmail.com>,
        andy@greyhouse.net, davem@davemloft.net, dvyukov@google.com,
        hans.verkuil@cisco.com, helen.koike@collabora.com,
        hverkuil@xs4all.nl, j.vosburgh@gmail.com,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, maheshb@google.com,
        mchehab+samsung@kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tfiga@chromium.org,
        vfalico@gmail.com
References: <000000000000c9f0a40596c1d46b@google.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <64d6d60b-bf1c-5fee-7049-9998afa0b91a@xs4all.nl>
Date:   Mon, 11 Nov 2019 15:00:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <000000000000c9f0a40596c1d46b@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfOHl9D+wKyXB/UKHzhTRNo/bH0ptWRXA/RYcpikmgu6qL0hiSXRduykPRWGLkrxvQx+BwdB4og683bob5Ie6B3rhZq0FJOuPn7Cv0rnyOenbDsLiSkPl
 MznSaZ9gqcGpEaCg+CdMrJjtIkvhyleO2uRjtXe3idj+BI5VmjOmVSjCqlzEkSbe4KT3RW5tkAK/amMQ3Z1u+AgkSQJ3fnB/gR1q//EaPnfUm1QNfA9wqwCz
 yrjHBdU8/cLv9KLRF6hBs6S3NFFkV383NGdVu+oLQBRJF+DL9p9raeyFjOU61oBEngkc1vuepGKwWCYT0Af/tftddaAMDbxBM+kaElkUwQEReMS1U0D2NGND
 1dPUCZlK3QSn9EeGc8jWnVLW9/hmeiYCBXMEDxTl9KQICbMcgF7fjhWHnZCwU6BYwLw2msNPKvx3OTdGikzY2q3UOSTmyEcVi2c9sxPCMIZfEKeOLbVgjrq6
 Z8XdCF41X0n4XgOctykRvz3A/trneh1DiLf5vFCUWNf02U7RskUMam8a/QDGlM3pdHPMNrfAH1R6arQAZA8qf9yRSQEflVYIPmJJyC2BZ0J5k+YRgtnIUj8+
 4AwSgoRtrcIVx9Kc+4IimkYx87GRHePI19aRIODPo9hQXq3zN2Y6nxH2L5QHli1dd9HAlMHb7+ppUh6GDm3aeqKU56oOmOOQ5Cd8/sMqko63yFWRPRH9/FkN
 /mse348+Hjh0jwFKTGyfpnnSQ/3R1VIxDlGmT6IARw7Z0ikaOjDqCIjYaYaHm0c0ltFsTYwfpkaclIjjknf6PqNNmDSEz9wnGKi8eHdS57j204nRnlx6NX4b
 Gp+lKpBuhaCa5l0eSM0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz fix: media: vb2: add waiting_in_dqbuf flag
